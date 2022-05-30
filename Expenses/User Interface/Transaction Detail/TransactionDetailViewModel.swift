//
//  TransactionDetailViewModel.swift
//  Expenses
//
//  Created by Nominalista on 21/12/2021.
//

import Combine
import Foundation

class TransactionDetailViewModel: ObservableObject {
    
    @Published var transaction: Transaction
    
    var formattedTags: String {
        transaction.tags.map { $0.name }.sorted(by: <).joined(separator: ", ")
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM YYYY • HH:mm"
        return formatter.string(from: transaction.date)
    }
    
    private let walletRepository: WalletRepository
    private let transactionRepository: TransactionRepository
    
    private var transactionObservationCancellable: AnyCancellable?
    
    init(
        walletRepostiory: WalletRepository,
        transactionRepository: TransactionRepository,
        transaction: Transaction
    ) {
        self.walletRepository = walletRepostiory
        self.transactionRepository = transactionRepository
        self.transaction = transaction
        
        let walletID = walletRepostiory.selectedWalletID ?? ""
        transactionObservationCancellable = transactionRepository
            .observeTransaction(withID: transaction.id, forWalletWithID: walletID)
            .sink { _ in
                
            } receiveValue: { [weak self] transaction in
                self?.transaction = transaction
            }
    }
    
    func deleteTransaction() {
        let walletID = walletRepository.selectedWalletID ?? ""
        transactionRepository.deleteTransaction(
            withID: transaction.id,
            forWalletWithID: walletID
        )
    }
}
