//
//  WalletsViewModel.swift
//  Expenses
//
//  Created by Nominalista on 06/01/2022.
//

import Combine
import Foundation

class WalletsViewModel: ObservableObject {
    
    @Published var wallets = [Wallet]()
    @Published var selectedWalletID: String?
    
    let dismissPublisher = PassthroughSubject<Void, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var walletRepository: WalletRepository
    
    init(walletRepository: WalletRepository) {
        self.walletRepository = walletRepository
        
        selectedWalletID = walletRepository.selectedWalletID
        walletRepository.observeWallets()
            .sink { _ in

            } receiveValue: { [weak self] wallets in
                self?.wallets = wallets.sorted(by: { $0.name < $1.name })
            }
            .store(in: &cancellables)
    }
    
    func select(wallet: Wallet) {
        selectedWalletID = wallet.id
    }
    
    func selectAndDismiss() {
        walletRepository.selectedWalletID = selectedWalletID
        dismissPublisher.send(())
    }
}
