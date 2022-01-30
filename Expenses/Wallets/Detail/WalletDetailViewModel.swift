//
//  WalletDetailViewModel.swift
//  Expenses
//
//  Created by Nominalista on 08/01/2022.
//

import Combine
import Foundation

class WalletDetailViewModel: ObservableObject {
    
    @Published var emoji: String
    @Published var name: String
    @Published var ownerName: String

    private var ownerID: String
    private var authorizedUserIDs: [String]
    
    @Published private(set) var contributors: [Wallet.User]
 
    private(set) var wallet: Wallet?
    
    var isEditable: Bool {
        ownerID == AuthState.shared.userID
    }
    
    var isDeletable: Bool {
        wallet != nil && isEditable
    }
    
    let dimissPublisher = PassthroughSubject<Bool, Never>()
    
    private let walletRepository: WalletRepository
    private let transactionRepository: TransactionRepository
    
    init(
        walletRepository: WalletRepository,
        transactionRepository: TransactionRepository,
        wallet: Wallet?
    ) {
        self.walletRepository = walletRepository
        self.transactionRepository = transactionRepository
        
        self.emoji = wallet?.emoji ?? Wallet.emojis.randomElement()!
        self.name = wallet?.name ?? ""
        
        if let wallet = wallet {
            self.ownerName = wallet.owner.name
            self.ownerID = wallet.owner.id
            self.contributors = wallet.contributors
            self.authorizedUserIDs = wallet.authorizedUserIDs
        } else {
            let userID = AuthState.shared.userID ?? ""
            self.ownerName = AuthState.shared.userDisplayName ?? ""
            self.ownerID = userID
            self.contributors = []
            self.authorizedUserIDs = [userID]
        }
        
        self.wallet = wallet
    }
    
    func shuffleEmoji() {
        emoji = Wallet.emojis.randomElement()!
    }
    
    func add(contributor: Wallet.User) {
        if !authorizedUserIDs.contains(contributor.id) {
            authorizedUserIDs.append(contributor.id)
        }
        if !contributors.contains(where: { $0.id == contributor.id }) {
            var contributors = contributors
            contributors.append(contributor)
            self.contributors = contributors.sorted(by: { $0.name < $1.name})
        }
    }
    
    func update(contributor: Wallet.User) {
        if let index = contributors.firstIndex(where: { $0.id == contributor.id }) {
            contributors[index] = contributor
        }
    }
    
    func deleteContributors(at indexSet: IndexSet) {
        let contributorsToDelete = indexSet.map { contributors[$0] }
        contributorsToDelete.forEach { contributor in
            authorizedUserIDs.removeAll(where: { $0 == contributor.id })
            contributors.removeAll(where: { $0.id == contributor.id })
        }
    }
    
    func save() {
        let owner = Wallet.User(id: ownerID, name: ownerName)
        
        if let wallet = wallet {
            let updatedWallet = Wallet(
                id: wallet.id,
                emoji: "",
                name: name,
                owner: owner,
                contributors: contributors,
                authorizedUserIDs: authorizedUserIDs
            )
            
            Task {
                switch await walletRepository.update(wallet: updatedWallet) {
                case .success:
                    print("Suceeded to update wallet.")
                    self.dimissPublisher.send(true)
                case .failure(let error):
                    print("Failed to update wallet (\(error.localizedDescription).")
                }
            }
        } else {
            let wallet = Wallet(
                id: "",
                emoji: "",
                name: name,
                owner: owner,
                contributors: contributors,
                authorizedUserIDs: authorizedUserIDs
            )
            Task {
                switch await walletRepository.update(wallet: wallet) {
                case .success:
                    print("Suceeded to insert wallet.")
                    self.dimissPublisher.send(true)
                case .failure(let error):
                    print("Failed to insert wallet (\(error.localizedDescription).")
                }
            }
        }
    }
    
    func delete() {
        guard let walletID = wallet?.id else { return }
        
        Task {
            walletRepository.delete(walletWithID: walletID)
            _ = await transactionRepository.deleteAllTransactions(fromWalletWithID: walletID)
            TagDataStore.shared.deleteAllTags(fromWalletWithID: walletID)
            dimissPublisher.send(true)
        }
    }
}
