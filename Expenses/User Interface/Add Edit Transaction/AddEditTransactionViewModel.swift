//
//  AddEditTransactionViewModel.swift
//  Expenses
//
//  Created by Nominalista on 05/12/2021.
//

import Foundation
import Combine

class AddEditTransactionViewModel: ObservableObject {
    
    let dismissPublisher = PassthroughSubject<Bool, Never>()
    
    @Published var type: TransactionType
    @Published var amount: String
    @Published var currency: String
    @Published var title: String
    @Published var tags: String
    @Published var date: Date
    @Published var notes: String
    
    private var selectedCurrency = Currency.USD {
        didSet { currency = "\(selectedCurrency.code) \(selectedCurrency.flag)" }
    }
    
    private var selectedTags = [Tag]() {
        didSet { tags = selectedTags.map { $0.name }.sorted(by: <).joined(separator: ", ") }
    }
    
    var transactionLimit: TransactionLimit?
    
    private var editedTransaction: Transaction?
    
    private let transactionRepository: TransactionRepository

    init(
        transactionRepository: TransactionRepository,
        transactionLimit: TransactionLimit? = nil,
        transaction: Transaction? = nil
    ) {
        self.transactionRepository = transactionRepository
        
        self.type = transaction?.type ?? .expense
        self.amount = transaction?.formattedAmountWithoutCurrency ?? ""
        self.currency = ""
        self.title = transaction?.title ?? ""
        self.tags = ""
        self.date = transaction?.date ?? .now
        self.notes = transaction?.notes ?? ""
        
        self.transactionLimit = transactionLimit
        self.editedTransaction = transaction
        
        defer {
            selectedTags = transaction?.tags ?? []
            selectedCurrency = transaction?.currency ?? getRecentCurrencyOrDefault()
        }
    }
    
    private func getRecentCurrencyOrDefault() -> Currency {
        guard let currencyCode = UserDefaults.standard.string(forKey: "recentCurrency") else {
            return .USD
        }
        return Currency(rawValue: currencyCode) ?? .USD
    }
    
    func createOrUpdateTransaction() {
        let amount = Transaction.formatter(for: nil)
            .number(from: amount)
            .map { Double(truncating: $0) } ?? 0.0
        
        let walletID = UserDefaults.standard.selectedWalletID ?? ""
        if let editedTransaction = editedTransaction {
            let updatedTransaction = Transaction(
                id: editedTransaction.id,
                type: type,
                amount: amount,
                currency: selectedCurrency,
                title: title,
                tags: selectedTags,
                date: date,
                notes: notes,
                timestamp: nil
            )
            
            _ = transactionRepository.update(
                transaction: updatedTransaction,
                forWalletWithID: walletID
            )
            dismissPublisher.send(true)
        } else {
            let transaction = Transaction(
                id: UUID().uuidString,
                type: type,
                amount: amount,
                currency: selectedCurrency,
                title: title,
                tags: selectedTags,
                date: date,
                notes: notes,
                timestamp: nil
            )
            
            _ = transactionRepository.insert(
                transaction: transaction,
                toWalletWithID: walletID
            )
            dismissPublisher.send(true)
        }
    }
    
    func select(currency: Currency) {
        selectedCurrency = currency
        UserDefaults.standard.set(currency.rawValue, forKey: "recentCurrency")
    }
    
    func select(tags: [Tag]) {
        selectedTags = tags
    }
}

