//
//  DataStore.swift
//  Expenses
//
//  Created by Nominalista on 12/12/2021.
//

import Foundation
import Firebase

enum FirebaseError: Error {
    case unknown
}

class DataStore {
    
    static let shared = DataStore()
    
    private var userID: String? {
        Auth.auth().currentUser?.uid
    }
    
    private var userDataReference: DocumentReference? {
        guard let userID = Auth.auth().currentUser?.uid else { return nil }
        return Firestore.firestore().collection("user-data").document(userID)
    }
    
    private var expensesReference: CollectionReference? {
        userDataReference?.collection("expenses")
    }
    
    private var tagsReference: CollectionReference? {
        userDataReference?.collection("tags")
    }
    
    private var firestore: Firestore {
        Firestore.firestore()
    }
    
    private init() {}
    
    /// New

    private func transactionsReference(forWalletWithID walletID: String) -> CollectionReference? {
        firestore.collection("wallet-transactions").document(walletID).collection("transactions")
    }
    
    private func tagsReference(forWalletWithID walletID: String) -> CollectionReference? {
        firestore.collection("wallet-tags").document(walletID).collection("tags")
    }
    
    func observeTransactions(
        forWalletWithID walletID: String,
        listener: @escaping (Result<[Transaction], Error>) -> Void
    ) -> ListenerRegistration? {
        transactionsReference(forWalletWithID: walletID)?.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                listener(.failure(error ?? FirebaseError.unknown)); return
            }
            let transactions = snapshot.documents.compactMap { $0.transactionOrNil() }
            listener(.success(transactions))
        }
    }
    
    
    /// Old
    
    // Transactions
    
    func observeExpenses(
        listener: @escaping ([Transaction]) -> Void
    ) -> ListenerRegistration? {
        return expensesReference?.addSnapshotListener({ snapshot, error in
            guard let snapshot = snapshot else { return }
            let transactions = snapshot
                .documents
                .compactMap { $0.transactionOrNil() }
            listener(transactions)
        })
    }
    
    func observeTransacton(
        withID id: String,
        listener: @escaping (Transaction) -> Void
    ) -> ListenerRegistration? {
        return expensesReference?.document(id).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot, let transaction = snapshot.transactionOrNil() else { return
            }
            listener(transaction)
        }
    }
    
    func insertTransaction(
        transaction: Transaction,
        completion: @escaping (Error?) -> Void
    ) {
        let data = transaction.data(withTimestamp: true)
        expensesReference?
            .document()
            .setData(data) { completion($0) }
    }
    
    func updateTransaction(
        transaction: Transaction,
        completion: @escaping (Error?) -> Void
    ) {
        let data = transaction.data(withTimestamp: false)
        expensesReference?
            .document(transaction.id)
            .updateData(data) { completion($0) }
    }
    
    func deleteTransaction(withID id: String) {
        expensesReference?
            .document(id)
            .delete()
    }
    
    func deleteAllTransactions(completion: @escaping (Error?) -> Void) {
        guard let expensesReference = expensesReference else { return }
        expensesReference.getDocuments { snapshot, error in
            guard let snapshot = snapshot else {
                completion(error)
                return
            }
            snapshot.documents.forEach { snapshot in
                expensesReference.document(snapshot.documentID).delete()
            }
            completion(nil)
        }
    }
    
    // Tags
    
    func observeTags(
        listener: @escaping ([Tag]) -> Void
    ) -> ListenerRegistration? {
        return tagsReference?.addSnapshotListener({ snapshot, error in
            guard let snapshot = snapshot else { return }
            let tags = snapshot
                .documents
                .compactMap { $0.tagOrNil() }
            listener(tags)
        })
    }
    
    func insert(tag: Tag,completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = ["name": tag.name]
        
        tagsReference?
            .document()
            .setData(data, completion: { error in
                completion(error)
            })
    }
    
    func deleteTag(withID id: String) {
        tagsReference?
            .document(id)
            .delete()
    }
}

private extension DocumentSnapshot {
    
    func transactionOrNil() -> Transaction? {
        guard let amount = get("amount") as? Double else { return nil }
        
        guard let title = get("title") as? String else { return nil }
        
        guard let currencyRawValue = get("currency") as? String,
              let currency = Currency(rawValue: currencyRawValue) else {
                  return nil
              }
        
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
            type: .expense,
            currency: currency,
            amount: amount,
            title: title,
            tags: tags,
            date: date,
            notes: notes,
            timestamp: timestamp
        )
    }
    
    func tagOrNil() -> Tag? {
        guard let name = get("name") as? String else { return nil }
        return Tag(id: documentID, name: name)
    }
}

private extension Transaction {
    
    func data(withTimestamp: Bool) -> [String: Any] {
        var data: [String: Any] = [
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
