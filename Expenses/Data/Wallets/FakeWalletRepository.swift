//
//  FakeWalletRepository.swift
//  Expenses
//
//  Created by Nominalista on 23/01/2022.
//

import Combine

class FakeWalletRepostiory: WalletRepository {
    
    var selectedWalletID: String? = Wallet.examples.first?.id
    
    func observeSelectedWalletID() -> AnyPublisher<String?, Never> {
        Just(selectedWalletID).eraseToAnyPublisher()
    }
    
    func observeWallets() -> AnyPublisher<[Wallet], Error> {
        Just(Wallet.examples)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func observeWallet(withID walletID: String) -> AnyPublisher<Wallet, Error> {
        Just(Wallet.examples.first  { $0.id == walletID })
            .compactMap { $0 }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func insert(wallet: Wallet) async -> Result<Wallet, Error> { fatalError() }
    
    func update(wallet: Wallet) async -> Result<Wallet, Error> { fatalError() }
    
    func delete(walletWithID walletID: String) { fatalError() }
}
