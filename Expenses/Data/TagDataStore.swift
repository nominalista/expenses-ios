//
//  TagDataStore.swift
//  Expenses
//
//  Created by Nominalista on 10/01/2022.
//

import Foundation
import FirebaseFirestore

class TagDataStore {
    
    static let shared = TagDataStore()
    
    private var firestore: Firestore {
        Firestore.firestore()
    }
    
    private init() {}
    
    private func tagsDocument(forWalletWithID walletID: String) -> DocumentReference {
        firestore.collection("tags").document(walletID)
    }
    
    private func tagsReference(forWalletWithID walletID: String) -> CollectionReference {
        firestore.collection("tags").document(walletID).collection("v1")
    }
    
    func observeTags(
        forWalletWithID walletID: String,
        listener: @escaping (Result<[Tag], Error>) -> Void
    ) -> ListenerRegistration {
        tagsReference(forWalletWithID: walletID).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                listener(.failure(error ?? FirebaseError.unknown)); return
            }
            let tags = snapshot.documents.compactMap { $0.tagOrNil() }
            listener(.success(tags))
        }
    }
    
    func getTags(forWalletWithID walletID: String) async -> Result<[Tag], Error> {
        do {
            let snapshot = try await tagsReference(forWalletWithID: walletID).getDocuments()
            let tags = snapshot.documents.compactMap { $0.tagOrNil() }
            return .success(tags)
        } catch let error {
            return .failure(error)
        }
    }
    
    func getTags(
        forWalletWithID walletID: String,
        completion: @escaping (Result<[Tag], Error>) -> Void
    ) {
        tagsReference(forWalletWithID: walletID).getDocuments { snapshot, error in
            guard let snapshot = snapshot else {
                completion(.failure(error ?? FirebaseError.unknown)); return
            }
            let tags = snapshot.documents.compactMap { $0.tagOrNil() }
            completion(.success(tags))
        }
    }
    
    func insert(tag: Tag, toWalletWithID walletID: String) async -> Result<Tag, Error> {
        do {
            let document = tagsReference(forWalletWithID: walletID).document()
            try await document.setData(tag.data)
            
            var tag = tag
            tag.id = document.documentID
            
            return .success(tag)
        } catch let error {
            return .failure(error)
        }
    }
    
    func insert(
        tag: Tag,
        forWalletWithID walletID: String,
        completion: @escaping (Result<Tag, Error>) -> Void
    ) {
        let document = tagsReference(forWalletWithID: walletID).document()
        document.setData(tag.data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                var tag = tag
                tag.id = document.documentID
                completion(.success(tag))
            }
        }
    }
    
    func deleteTag(withID id: String, forWalletWithID walletID: String) {
        tagsReference(forWalletWithID: walletID)
            .document(id)
            .delete()
    }
    
    func deleteAllTags(fromWalletWithID walletID: String) {
        tagsDocument(forWalletWithID: walletID).delete()
    }
}

extension DocumentSnapshot {
    
    func tagOrNil() -> Tag? {
        guard let name = get("name") as? String else { return nil }
        return Tag(id: documentID, name: name)
    }
}

extension Tag {
    
    var data: [String: Any] {
        ["name": name]
    }
}
