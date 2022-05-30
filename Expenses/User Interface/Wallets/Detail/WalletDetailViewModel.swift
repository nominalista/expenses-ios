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
        ownerID == AuthState.shared.user?.id
    }
    
    var isDeletable: Bool {
        wallet != nil && isEditable
    }
    
    let dismissPublisher = PassthroughSubject<Bool, Never>()
    
    private let walletRepository: WalletRepository
    private let transactionRepository: TransactionRepository
    private let tagRepository: TagRepository
    
    init(
        walletRepository: WalletRepository,
        transactionRepository: TransactionRepository,
        tagRepository: TagRepository,
        wallet: Wallet?
    ) {
        self.walletRepository = walletRepository
        self.transactionRepository = transactionRepository
        self.tagRepository = tagRepository
        
        self.emoji = wallet?.emoji ?? Wallet.emojis.randomElement()!
        self.name = wallet?.name ?? ""
        
        if let wallet = wallet {
            self.ownerName = wallet.owner.name
            self.ownerID = wallet.owner.id
            self.authorizedUserIDs = wallet.authorizedUserIDs
            self.contributors = wallet.contributors
        } else {
            let userID = AuthState.shared.user?.id ?? ""
            self.ownerName = AuthState.shared.user?.displayName ?? ""
            self.ownerID = userID
            self.authorizedUserIDs = [userID]
            self.contributors = []
        }
        self.wallet = wallet
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
            var contributors = contributors
            contributors[index] = contributor
            self.contributors = contributors
        }
    }
    
    func delete(contributor: Wallet.User) {
        authorizedUserIDs.removeAll { $0 == contributor.id }
        contributors.removeAll { $0.id == contributor.id }
    }
    
    func shuffleEmoji() {
        emoji = Wallet.emojis.randomElement()!
    }
    
    func save() {
        let owner = Wallet.User(id: ownerID, name: ownerName)
        
        if let wallet = wallet {
            let updatedWallet = Wallet(
                id: wallet.id,
                emoji: emoji,
                name: name,
                owner: owner,
                contributors: contributors,
                authorizedUserIDs: authorizedUserIDs
            )
            _ = walletRepository.update(wallet: updatedWallet)
        } else {
            let wallet = Wallet(
                id: "",
                emoji: emoji,
                name: name,
                owner: owner,
                contributors: contributors,
                authorizedUserIDs: authorizedUserIDs
            )
            _ = walletRepository.insert(wallet: wallet)
        }
        dismissPublisher.send(true)
    }
    
    func delete() {
        guard let walletID = wallet?.id else { return }
        
        Task {
            walletRepository.delete(walletWithID: walletID)
            _ = await transactionRepository.deleteAllTransactions(fromWalletWithID: walletID)
            _ = await tagRepository.deleteAllTags(fromWalletWithID: walletID)
            dismissPublisher.send(true)
        }
    }
}

extension WalletDetailViewModel {
    
    static func firebase(for wallet: Wallet) -> WalletDetailViewModel {
        WalletDetailViewModel(
            walletRepository: FirebaseWalletRepository.shared,
            transactionRepository: FirebaseTransactionRepository.shared,
            tagRepository: FirebaseTagRepository.shared,
            wallet: wallet
        )
    }
    
    static func preview(for wallet: Wallet) -> WalletDetailViewModel {
        WalletDetailViewModel(
            walletRepository: FakeWalletRepostiory(),
            transactionRepository: FakeTransactionRepository(),
            tagRepository: FakeTagRepository(),
            wallet: wallet
        )
    }
}
