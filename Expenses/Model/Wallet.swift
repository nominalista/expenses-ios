//
//  Wallet.swift
//  Expenses
//
//  Created by Nominalista on 06/01/2022.
//

import Foundation

struct Wallet {
    
    static var emojis: [String] {
        ["💵", "💸", "💰", "💳", "🏠", "✈️", "🏝"]
    }

    var id: String
    var emoji: String
    var name: String
    var owner: User
    var contributors: [User]
    var authorizedUserIDs: [String]
    
    struct User {
        let id: String
        let name: String
    }
}
