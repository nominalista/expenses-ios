//
//  Wallet+Examples.swift
//  Expenses
//
//  Created by Nominalista on 22/01/2022.
//

import Foundation

extension Wallet {
    
    static var examples: [Wallet] {
        [.myWallet, .home, .trip]
    }
    
    static var myWallet: Wallet {
        let owner: Wallet.User = .johnDoe
        let contributors: [Wallet.User] = []
        let authorizedUserIDs: [String] = [owner.id]
        return Wallet(
            id: "my_wallet",
            emoji: "💵",
            name: "My Wallet",
            owner: owner,
            contributors: contributors,
            authorizedUserIDs: authorizedUserIDs
        )
    }
    
    static var home: Wallet {
        let owner: Wallet.User = .emmaMiller
        let contributors: [Wallet.User] = [.johnDoe, .richardRoger]
        let authorizedUserIDs: [String] = [owner.id] + contributors.map { $0.id }
        return Wallet(
            id: "home",
            emoji: "🏠",
            name: "Home",
            owner: owner,
            contributors: contributors,
            authorizedUserIDs: authorizedUserIDs
        )
    }
    
    static var trip: Wallet {
        let owner: Wallet.User = .richardRoger
        let contributors: [Wallet.User] = [.johnDoe, .emmaMiller]
        let authorizedUserIDs: [String] = [owner.id] + contributors.map { $0.id }
        return Wallet(
            id: "trip",
            emoji: "🏝",
            name: "Trip",
            owner: owner,
            contributors: contributors,
            authorizedUserIDs: authorizedUserIDs
        )
    }
}

extension Wallet.User {
    
    static var johnDoe: Wallet.User {
        Wallet.User(id: "john_doe", name: "John Doe")
    }
    
    static var emmaMiller: Wallet.User {
        Wallet.User(id: "emma_miller", name: "Emma Miller")
    }
    
    static var richardRoger: Wallet.User {
        Wallet.User(id: "richard_roger", name: "Richard Roger")
    }
}
