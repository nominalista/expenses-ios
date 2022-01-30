//
//  FakeTransactionRepostiory.swift
//  Expenses
//
//  Created by Nominalista on 30/01/2022.
//

import Combine
import Foundation

class FakeTransactionRepository: TransactionRepository {
    
    func observeTransactions(
        forWalletWithID walletID: String
    ) -> AnyPublisher<[Transaction], Error> {
        Just(Transaction.examples)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func observeTransaction(
        withID id: String,
        forWalletWithID walletID: String
    ) -> AnyPublisher<Transaction, Error> {
        Just(Transaction.examples.first  { $0.id == id })
            .compactMap { $0 }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func insert(
        transaction: Transaction,
        toWalletWithID walletID: String
    ) -> Transaction {
        fatalError("Not implemented.")
    }
    
    func update(
        transaction: Transaction,
        forWalletWithID walletID: String
    ) -> Transaction {
        fatalError("Not implemented.")
    }
    
    func deleteTransaction(
        withID id: String,
        forWalletWithID walletID: String
    ) {
        fatalError("Not implemented.")
    }
    
    func deleteAllTransactions(
        fromWalletWithID walletID: String
    ) async -> Result<Void, Error> {
        fatalError("Not implemented.")
    }
}

