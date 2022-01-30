//
//  FirebaseWalletRepository.swift
//  Expenses
//
//  Created by Nominalista on 23/01/2022.
//

import Combine
import FirebaseAuth
import FirebaseFirestore

class FirebaseWalletRepository: WalletRepository {
    
    static var shared = FirebaseWalletRepository()
        
    private var userID: String? {
        Auth.auth().currentUser?.uid
    }
    
    private var firestore: Firestore {
        Firestore.firestore()
    }
    
    private var walletsReference: CollectionReference {
        firestore.collection("wallets")
    }
    
    private init() {}
    
    var selectedWalletID: String? {
        get { UserDefaults.standard.selectedWalletID }
        set { UserDefaults.standard.selectedWalletID = newValue }
    }
    
    func observeSelectedWalletID() -> AnyPublisher<String?, Never> {
        UserDefaults.standard.publisher(for: \.selectedWalletID).eraseToAnyPublisher()
    }
    
    func observeWallets() -> AnyPublisher<[Wallet], Error> {
        walletsReference
            .whereField("authorizedUserIds", arrayContains: userID ?? ())
            .publisher()
            .map { $0.documents.compactMap { $0.walletOrNil() } }
            .eraseToAnyPublisher()
    }
    
    func observeWallet(withID walletID: String) -> AnyPublisher<Wallet, Error> {
        walletsReference
            .document(walletID)
            .publisher()
            .compactMap { $0.walletOrNil() }
            .eraseToAnyPublisher()
    }
    
    func insert(wallet: Wallet) async -> Result<Wallet, Error> {
        do {
            let document = walletsReference.document()
            try await document.setData(wallet.data)
            
            var wallet = wallet
            wallet.id = document.documentID
            
            return .success(wallet)
        } catch let error {
            return .failure(error)
        }
    }
    
    func update(wallet: Wallet) async -> Result<Wallet, Error> {
        do {
            let document = walletsReference.document(wallet.id)
            try await document.setData(wallet.data)
            
            return .success(wallet)
        } catch let error {
            return .failure(error)
        }
    }
    
    func delete(walletWithID walletID: String) {
        walletsReference.document(walletID).delete()
    }
}

private extension DocumentSnapshot {
    
    func walletOrNil() -> Wallet? {
        guard let emoji = get("emoji") as? String,
              let name = get("name") as? String,
              let ownerData = get("owner") as? [String: Any],
              let contributorsData = get("contributors") as? [[String: Any]],
              let authorizedUserIDs = get("authorizedUserIds") as? [String] else {
                  return nil
              }
        
        guard let owner = userOrNil(from: ownerData) else {
            return nil
        }
        
        let contributors = contributorsData.compactMap { userOrNil(from: $0) }
        
        return Wallet(
            id: documentID,
            emoji: emoji,
            name: name,
            owner: owner,
            contributors: contributors,
            authorizedUserIDs: authorizedUserIDs
        )
    }
    
    private func userOrNil(from data: [String: Any]) -> Wallet.User? {
        guard let id = data["id"] as? String, let name = data["name"] as? String else {
            return nil
        }
        return Wallet.User(id: id, name: name)
    }
}

private extension Wallet {
    
    var data: [String: Any] {
        [
            "name": name,
            "emoji": emoji,
            "owner": owner.data,
            "contributors": contributors.map { $0.data },
            "authorizedUserIds": authorizedUserIDs
        ]
    }
}

private extension Wallet.User {
    
    var data: [String: Any] {
        ["id": id, "name": name]
    }
}

