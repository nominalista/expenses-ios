//
//  HomeViewModel.swift
//  Expenses
//
//  Created by Nominalista on 12/12/2021.
//

import Combine
import Foundation
import SwiftUI

@MainActor class HomeViewModel: ObservableObject {
    
    @Published private(set) var selectedWallet: Wallet?
    @Published private(set) var viewState = HomeViewState()
    
    @Published var isImporting = false
    @Published var isExporting = false
    
    @Published var backgroundColors: [Color] = [Color(.sRGB, red: 57/255, green: 123/255, blue: 68/255, opacity: 1.0), Color(.sRGB, red: 70/255, green: 144/255, blue: 148/255, opacity: 1.0)]
    
    var transactionLimit: TransactionLimit? {
        if let subscriptionStatus = subscriptionManager.status, subscriptionStatus.isSubscribed {
            return nil
        }
        return TransactionLimit(
            currentNumberOfTransactions: viewState.transactions.count,
            maxNumberOfTransactions: 100
        )
    }
    
    let showActivityView = PassthroughSubject<URL, Never>()
    let showImportErrorAlert = PassthroughSubject<String, Never>()
    
    private var walletRepository: WalletRepository
    private var transactionRepostiory: TransactionRepository
    private var tagRepository: TagRepository
    private var subscriptionManager: SubscriptionManager
        
    private var userDefaultsCancellable: AnyCancellable?
    private var walletObservationCancellable: AnyCancellable?
    private var transactionsObservationCancellable: AnyCancellable?
    
    init(
        walletRepository: WalletRepository,
        transactionRepostiory: TransactionRepository,
        tagRepository: TagRepository,
        subscriptionManager: SubscriptionManager
    ) {
        self.walletRepository = walletRepository
        self.transactionRepostiory = transactionRepostiory
        self.tagRepository = tagRepository
        self.subscriptionManager = subscriptionManager
        observeSelectedWallet()
    }
    
    private func observeSelectedWallet() {
        userDefaultsCancellable = walletRepository.observeSelectedWalletID()
            .sink { [weak self] selectedWalletID in
                if let selectedWalletID = selectedWalletID {
                    self?.observeWallet(withID: selectedWalletID)
                    self?.observeTransactions(forWalletWithID: selectedWalletID)
                    self?.applyFilters(dateRange: .allTime, tags: [])
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
                guard let self = self else { return }
                self.viewState = self.viewState.copy(transactions: [])
            } receiveValue: { [weak self] transactions in
                guard let self = self else { return }
                self.viewState = self.viewState.copy(transactions: transactions)
            }
    }
    
    func applyFilters(dateRange: DateRange, tags: Set<Tag>) {
        viewState = viewState.copy(filterDateRange: dateRange, filterTags: tags)
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
            let result = await Importer(
                transactionRepository: self.transactionRepostiory,
                tagRepository: self.tagRepository
            ).importTransactions(from: url, toWalletWithID: walletID)
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
                let url = try await Exporter.exportToCSV(from: self.viewState.transactions)
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

extension HomeViewModel {
    
    static var firebase: HomeViewModel {
        HomeViewModel(
            walletRepository: FirebaseWalletRepository.shared,
            transactionRepostiory: FirebaseTransactionRepository.shared,
            tagRepository: FirebaseTagRepository.shared,
            subscriptionManager: SubscriptionManager.shared
        )
    }
    
    static var preview: HomeViewModel {
        HomeViewModel(
            walletRepository: FakeWalletRepostiory(),
            transactionRepostiory: FakeTransactionRepository(),
            tagRepository: FakeTagRepository(),
            subscriptionManager: SubscriptionManager.shared
        )
    }
}
