//
//  HomeViewModel.swift
//  Expenses
//
//  Created by Nominalista on 12/12/2021.
//

import Combine
import Foundation

@MainActor class HomeViewModel: ObservableObject {
    
    var userDisplayName: String? { AuthState.shared.userDisplayName }
    var userEmail: String? { AuthState.shared.userEmail }
    
    @Published private(set) var selectedWallet: Wallet?
    
    @Published private(set) var transactions = [Transaction]() {
        didSet { updateTransactionsDependentFields() }
    }
    
    @Published private(set) var transactionSummary = TransactionSummary()
    @Published private(set) var sectionedTransactions = SectionedTransactions()
    
    @Published var isImporting = false
    @Published var isExporting = false
    
    let showActivityView = PassthroughSubject<URL, Never>()
    let showImportErrorAlert = PassthroughSubject<String, Never>()
    
    private(set) var filterDateRange: FilterDateRange = .allTime
    private(set) var filterTags: Set<Tag> = Set()
    
    private var walletRepository: WalletRepository
    private var transactionRepostiory: TransactionRepository
        
    private var userDefaultsCancellable: AnyCancellable?
    private var walletObservationCancellable: AnyCancellable?
    private var transactionsObservationCancellable: AnyCancellable?
    
    init(
        walletRepository: WalletRepository,
        transactionRepostiory: TransactionRepository
    ) {
        self.walletRepository = walletRepository
        self.transactionRepostiory = transactionRepostiory
        observeSelectedWallet()
    }
    
    private func observeSelectedWallet() {
        userDefaultsCancellable = walletRepository.observeSelectedWalletID()
            .sink { [weak self] selectedWalletID in
                if let selectedWalletID = selectedWalletID {
                    self?.observeWallet(withID: selectedWalletID)
                    self?.observeTransactions(forWalletWithID: selectedWalletID)
                }
            }
    }
    
    private func observeWallet(withID walletID: String) {
        walletObservationCancellable?.cancel()
        walletObservationCancellable = walletRepository.observeWallet(withID: walletID)
            .sink { [weak self] _ in
                self?.selectedWallet = nil
            } receiveValue: { [weak self] wallet in
                self?.selectedWallet = wallet
            }
    }
    
    private func observeTransactions(forWalletWithID walletID: String) {
        transactionsObservationCancellable?.cancel()
        transactionsObservationCancellable = transactionRepostiory
            .observeTransactions(forWalletWithID: walletID)
            .sink{ [weak self] _ in
                self?.transactions = []
            } receiveValue: { [weak self] transactions in
                self?.transactions = transactions
            }
    }
    
    private func updateTransactionsDependentFields() {
        let filteredTransactions = transactions.filter { shouldInclude(transaction: $0) }
        self.transactionSummary = TransactionSummary(transactions: filteredTransactions)
        self.sectionedTransactions = SectionedTransactions(transactions: filteredTransactions)
    }
    
    private func shouldInclude(transaction: Transaction) -> Bool {
        shouldIncludeByDateRange(transaction: transaction) &&
        shouldIncludeByTags(transaction: transaction)
    }
    
    private func shouldIncludeByDateRange(transaction: Transaction) -> Bool {
        filterDateRange.filter(transaction: transaction)
    }
    
    private func shouldIncludeByTags(transaction: Transaction) -> Bool {
        guard !filterTags.isEmpty else { return true }
        return transaction.tags.contains(where: { filterTags.contains($0) })
    }
    
    func logOut() {
        walletRepository.selectedWalletID = nil
        AuthState.shared.logOut()
    }
    
    func applyFilters(dateRange: FilterDateRange, tags: Set<Tag>) {
        self.filterDateRange = dateRange
        self.filterTags = tags
        updateTransactionsDependentFields()
    }
    
    func importTransactions(from result: Result<[URL], Error>) {
        guard case .success(let urls) = result, let url = urls.first else {
            print("No file URL for transaction import.")
            return
        }
        
        guard let walletID = selectedWallet?.id else {
            print("No wallet selected. Can't import transactions.")
            return
        }
        
        isImporting = true
        Task.detached(priority: .userInitiated) {
            let result = await Importer(transactionRepository: self.transactionRepostiory)
                .importTransactions(from: url, toWalletWithID: walletID)
            await self.finishImport(with: result)
        }
    }
    
    private func finishImport(with result: Result<Void, Error>) {
        isImporting = false
        
        switch result {
        case .success:
            print("Succeeded to import transactions.")
        case .failure(let error):
            print("Failed to import transactions: \(error.localizedDescription).")
            let alertMessage = ImportErrorHandler.handle(error: error)
            showImportErrorAlert.send(alertMessage)
        }
    }
    
    func exportCSV() {
        isExporting = true
        Task.detached(priority: .userInitiated) {
            do {
                let url = try await Exporter.exportToCSV(from: self.transactions)
                await self.finishExporting(csvURL: url)
            } catch let error {
                print("Failed to export transactions: \(error.localizedDescription).")
            }
        }
    }
    
    private func finishExporting(csvURL: URL) {
        isExporting = false
        showActivityView.send(csvURL)
    }
    
    func deleteExportedCSV(url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Failed to delete CSV at: \(url).")
        }
    }
    
    func deleteAllTransactions() {
        guard let walletID = selectedWallet?.id else { return }
        Task {
            switch await transactionRepostiory.deleteAllTransactions(fromWalletWithID: walletID) {
            case .success:
                print("Succeeded to delete all transactions.")
            case .failure(let error):
                print("Failed to delete all transactions (\(error.localizedDescription)).")
            }
        }
    }
}
