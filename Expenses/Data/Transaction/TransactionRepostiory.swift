//
//  TransactionRepostiory.swift
//  Expenses
//
//  Created by Nominalista on 30/01/2022.
//

import Combine
import Foundation

protocol TransactionRepository {
    
    func observeTransactions(
        forWalletWithID walletID: String
    ) -> AnyPublisher<[Transaction], Error>
    
    func observeTransaction(
        withID id: String,
        forWalletWithID walletID: String
    ) -> AnyPublisher<Transaction, Error>
    
    func insert(
        transaction: Transaction,
        toWalletWithID walletID: String
    ) -> Transaction
    
    func update(
        transaction: Transaction,
        forWalletWithID walletID: String
    ) -> Transaction
    
    func deleteTransaction(
        withID id: String,
        forWalletWithID walletID: String
    )
    
    func deleteAllTransactions(
        fromWalletWithID walletID: String
    ) async -> Result<Void, Error>
}
