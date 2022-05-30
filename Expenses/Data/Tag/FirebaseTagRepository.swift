//
//  FirebaseTagRepository.swift
//  Expenses
//
//  Created by Nominalista on 06/02/2022.
//

import Combine
import FirebaseFirestore

class FirebaseTagRepository: TagRepository {
    
    static let shared = FirebaseTagRepository()
    
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
    
    func observeTags(forWalletWithID walletID: String) -> AnyPublisher<[Tag], Error> {
        tagsReference(forWalletWithID: walletID)
            .publisher()
            .map { $0.documents.compactMap { $0.tagOrNil() } }
            .eraseToAnyPublisher()
    }
    
    func getTags(forWalletWithID walletID: String) async -> Result<[Tag], Error> {
        do {
            let querySnapshot = try await tagsReference(forWalletWithID: walletID).getDocuments()
            let tags = querySnapshot.documents.compactMap { $0.tagOrNil() }
            return .success(tags)
        } catch let error {
            return .failure(error)
        }
    }
    
    func insert(tag: Tag, toWalletWithID walletID: String) -> Tag {
        let document = tagsReference(forWalletWithID: walletID).document()
        document.setData(tag.data)
        
        var tag = tag
        tag.id = document.documentID
        return tag
    }
    
    func deleteTag(withID id: String, forWalletWithID walletID: String) {
        tagsReference(forWalletWithID: walletID).document(id).delete()
    }
    
    func deleteAllTags(fromWalletWithID walletID: String) async -> Result<Void, Error> {
        do {
            try await tagsReference(forWalletWithID: walletID)
                .getDocuments()
                .documents
                .forEach { $0.reference.delete() }
            
            return .success(())
        } catch let error {
            return .failure(error)
        }
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
