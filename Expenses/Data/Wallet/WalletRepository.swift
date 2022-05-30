//
//  WalletRepository.swift
//  Expenses
//
//  Created by Nominalista on 08/01/2022.
//

import Combine
import Foundation

protocol WalletRepository {
    
    var selectedWalletID: String? { get set }
    
    func observeSelectedWalletID() -> AnyPublisher<String?, Never>
    
    func observeWallets() -> AnyPublisher<[Wallet], Error>
    
    func getWallets() async -> Result<[Wallet], Error>
    
    func observeWallet(withID walletID: String) -> AnyPublisher<Wallet, Error>
    
    func insert(wallet: Wallet) -> Wallet
    
    func update(wallet: Wallet) -> Wallet
    
    func delete(walletWithID walletID: String)
}
