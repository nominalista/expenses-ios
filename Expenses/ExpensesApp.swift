//
//  ExpensesApp.swift
//  Expenses
//
//  Created by Nominalista on 04/12/2021.
//

import FirebaseCore
import SwiftUI
import UIKit

let githubURL = URL(string: "https://www.github.com/nominalista/expenses-ios")!
let privacyPolicyURL = URL(string: "https://www.github.com/nominalista/expenses-ios")!

@main
struct ExpensesApp: App {
    
    @UIApplicationDelegateAdaptor(ExpensesAppDelegate.self) var appDelegate
        
    init() {
        FirebaseApp.configure()
        UITableView.appearance().backgroundColor = .clear
        //UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some Scene {
        WindowGroup {
            ExpenseAppContent()
        }
    }
}

struct ExpenseAppContent: View {
    
    @StateObject var authState = AuthState.shared
    
    var body: some View {
        if authState.user != nil {
            HomeView(viewModel: .firebase)
        } else {
            WelcomeView(viewModel: .firebase)
        }
    }
}
