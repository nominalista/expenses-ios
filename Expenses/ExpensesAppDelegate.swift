//
//  ExpenseAppDelegate.swift
//  Expenses
//
//  Created by Nominalista on 07/12/2021.
//

import FirebaseCore
import FirebaseFirestore
import Foundation
import GoogleSignIn
import UIKit

class ExpensesAppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        print(NSHomeDirectory())
        SubscriptionManager.shared.listenForTransacionUpdates()
        UITextView.appearance().backgroundColor = .clear
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

