//
//  ExpensesApp.swift
//  Expenses
//
//  Created by Nominalista on 04/12/2021.
//

import SwiftUI
import UIKit

@main
struct ExpensesApp: App {
    
    @UIApplicationDelegateAdaptor(ExpensesAppDelegate.self) var appDelegate
    
    @ObservedObject var authState = AuthState.shared
    
    var body: some Scene {
        WindowGroup {
            if authState.isUserLoggedIn {
                let viewModel = HomeViewModel(
                    walletRepository: FirebaseWalletRepository.shared,
                    transactionRepostiory: FirebaseTransactionRepository.shared
                )
                HomeView(viewModel: viewModel)
            } else {
                WelcomeView()
            }
        }
    }
}
