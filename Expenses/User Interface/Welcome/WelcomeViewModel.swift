//
//  WelcomeViewModel.swift
//  Expenses
//
//  Created by Nominalista on 07/12/2021.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn
import FirebaseAuth
import SwiftUI

@MainActor class WelcomeViewModel: NSObject, ObservableObject {
    
    @Published var isSigningInWithApple = false
    @Published var isSigningInWithGoogle = false
    
    private var walletRepository: WalletRepository
    
    init(walletRepository: WalletRepository) {
        self.walletRepository = walletRepository
    }
    
    func signInWithApple() {
        isSigningInWithApple = true
        Task {
            switch await AuthState.shared.signInWithApple() {
            case .success:
                print("Succeeded to sign in with Apple.")
                await selectDefaultWallet()
            case .failure(let error):
                print("Failed to sign in with Apple: \(error).")
            }
            isSigningInWithApple = false
        }
    }

    func signInWithGoogle() {
        isSigningInWithGoogle = true
        Task {
            switch await AuthState.shared.signInWithGoogle() {
            case .success:
                print("Succeeded to sign in with Google.")
                await selectDefaultWallet()
            case .failure(let error):
                print("Failed to sign in with Google: \(error).")
            }
            isSigningInWithGoogle = false
        }
    }
    
    private func selectDefaultWallet() async {
        do {
            let wallets = try await walletRepository.getWallets().get()
            if !wallets.isEmpty {
                walletRepository.selectedWalletID = wallets.sorted { $0.name < $1.name }.first?.id
                print("Selected first wallet from repository.")
            } else {
                walletRepository.selectedWalletID = try makeMyWallet().id
                print("No wallets in repository, 'My wallet' created.")
            }
        } catch let error {
            print("Failed to select a default wallet (\(error)).")
        }
    }
    
    private func makeMyWallet() throws -> Wallet {
        let user = try AuthState.shared.requireUser()
        let wallet = Wallet.myWallet(ownerID: user.id, ownerName: user.displayName ?? "No name")
        return walletRepository.insert(wallet: wallet)
    }
}

extension WelcomeViewModel {
    
    static var firebase: WelcomeViewModel {
        WelcomeViewModel(walletRepository: FirebaseWalletRepository.shared)
    }
    
    static var preview: WelcomeViewModel {
        WelcomeViewModel(walletRepository: FakeWalletRepostiory())
    }
}
