//
//  ProfileViewModel.swift
//  Expenses
//
//  Created by Nominalista on 12/02/2022.
//

import Combine
import Foundation

@MainActor class ProfileViewModel: ObservableObject {
    
    var userDisplayName: String {
        authState.user?.displayName ?? "No name"
    }
    var userEmail: String {
        authState.user?.email ?? "no@name.com"
    }
    var profileID: String {
        authState.user?.id.base64Encoded ?? "Invalid ID"
    }
    
    @Published var hasExpensesPlus = false
    private lazy var hasExpensesPlusPublisher: Published<Bool>.Publisher = $hasExpensesPlus
    
    @Published var isDeletingAccount = false
    let showAccountDeletedConfirmation = PassthroughSubject<Void, Never>()
    
    private var authState: AuthState
    private var subscriptionManager: SubscriptionManager
    private var walletRepository: WalletRepository
    
    init(
        authState: AuthState,
        subscriptionManager: SubscriptionManager,
        walletRepository: WalletRepository
    ) {
        self.authState = authState
        self.subscriptionManager = subscriptionManager
        self.walletRepository = walletRepository
        
        subscriptionManager.$status
            .map { $0?.isSubscribed ?? false }
            .assign(to: &hasExpensesPlusPublisher)
    }

    func logOut() {
        walletRepository.selectedWalletID = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.authState.signOut()
        }
    }
    
    func deleteAccount() {
        guard !isDeletingAccount else { return }
        Task {
            isDeletingAccount = true
            do {
                try await authState.deleteUser()
                showAccountDeletedConfirmation.send()
            } catch {
                print("Failed to delete user (\(error)).")
            }
            isDeletingAccount = false
        }
    }
}

extension ProfileViewModel {
    
    static var firebase: ProfileViewModel {
        ProfileViewModel(
            authState: AuthState.shared,
            subscriptionManager: SubscriptionManager.shared,
            walletRepository: FirebaseWalletRepository.shared
        )
    }
    
    static var preview: ProfileViewModel {
        ProfileViewModel(
            authState: AuthState.shared,
            subscriptionManager: SubscriptionManager.shared,
            walletRepository: FakeWalletRepostiory()
        )
    }
}
