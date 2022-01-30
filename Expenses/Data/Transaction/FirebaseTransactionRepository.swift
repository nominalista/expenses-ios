//
//  FirebaseTransactionRepository.swift
//  Expenses
//
//  Created by Nominalista on 30/01/2022.
//

import Combine
import Foundation
import FirebaseFirestore

class FirebaseTransactionRepository: TransactionRepository {
    
    static var shared = FirebaseTransactionRepository()
    
    private var firestore: Firestore {
        Firestore.firestore()
    }
    
    private init() {}
    
    private func transactionsDocument(forWalletWithID walletID: String) -> DocumentReference {
        firestore.collection("transactions").document(walletID)
    }
    
    private func transactionsReference(forWalletWithID walletID: String) -> CollectionReference {
        firestore.collection("transactions").document(walletID).collection("v1")
    }
    
    func observeTransactions(
        forWalletWithID walletID: String
    ) -> AnyPublisher<[Transaction], Error> {
        transactionsReference(forWalletWithID: walletID)
            .publisher()
            .map { $0.documents.compactMap { $0.transactionOrNil() } }
            .eraseToAnyPublisher()
    }
    
    func observeTransaction(
        withID id: String,
        forWalletWithID walletID: String
    ) -> AnyPublisher<Transaction, Error> {
        transactionsReference(forWalletWithID: walletID)
            .document(id)
            .publisher()
            .compactMap { $0.transactionOrNil() }
            .eraseToAnyPublisher()
    }
    
    func insert(transaction: Transaction, toWalletWithID walletID: String) -> Transaction {
        let document = transactionsReference(forWalletWithID: walletID).document()
        document.setData(transaction.data(withTimestamp: true))
        
        var transaction = transaction
        transaction.id = document.documentID
        return transaction
    }
    
    func update(transaction: Transaction,forWalletWithID walletID: String) -> Transaction {
        let document = transactionsReference(forWalletWithID: walletID).document(transaction.id)
        document.updateData(transaction.data(withTimestamp: true))
        return transaction
    }
    
    func deleteTransaction(withID id: String, forWalletWithID walletID: String) {
        transactionsReference(forWalletWithID: walletID)
            .document(id)
            .delete()
    }
    
    func deleteAllTransactions(fromWalletWithID walletID: String) async -> Result<Void, Error> {
        do {
            try await transactionsReference(forWalletWithID: walletID)
                .getDocuments()
                .documents
                .forEach { $0.reference.delete() }
            
            return .success(())
        } catch let error {
            return .failure(error)
        }
    }
}

private extension DocumentSnapshot {
    
    func transactionOrNil() -> Transaction? {
        guard let typeRawValue = get("type") as? String,
              let type = TransactionType(rawValue: typeRawValue) else { return nil }
        
        guard let amount = get("amount") as? Double else { return nil }
        
        guard let title = get("title") as? String else { return nil }
        
        guard let currencyRawValue = get("currency") as? String,
              let currency = Currency(rawValue: currencyRawValue) else { return nil }
        
        guard let millis = get("date") as? Int else { return nil }
        let date = Date(millis: millis)
        
        guard let tagsData = get("tags") as? [[String: Any]] else { return nil }
        let tags: [Tag] = tagsData.compactMap {
            guard let id = $0["id"] as? String,
                  let name = $0["name"] as? String else {
                      return nil
                  }
            return Tag(id: id, name: name)
        }
        
        guard let notes = get("notes") as? String else { return nil }
        
        let firTimestamp = get("timestamp") as? Timestamp
        let timestamp = firTimestamp?.dateValue().millisSince1970
        
        return Transaction(
            id: documentID,
            type: type,
            amount: amount,
            currency: currency,
            title: title,
            tags: tags,
            date: date,
            notes: notes,
            timestamp: timestamp
        )
    }
}

private extension Transaction {
    
    func data(withTimestamp: Bool) -> [String: Any] {
        var data: [String: Any] = [
            "type": type.rawValue,
            "amount": amount,
            "currency": currency.rawValue,
            "title": title,
            "tags": tags.map { ["id": $0.id, "name": $0.name] },
            "date": date.millisSince1970,
            "notes": notes
        ]
        
        if withTimestamp {
            data["timestamp"] = FieldValue.serverTimestamp()
        }
        
        return data
    }
}


