//
//  Transaction+Examples.swift
//  Expenses
//
//  Created by Nominalista on 15/01/2022.
//

import Foundation

extension Transaction {
    
    static var examples: [Transaction] {
        [.example]
    }
    
    static var example: Transaction {
        Transaction(
            type: .expense,
            amount: 1234.99,
            currency: .USD,
            title: "Example",
            tags: [Tag(name: "tag1"), Tag(name: "tag2"), Tag(name: "tag3")],
            date: .now,
            notes: "My notes."
        )
    }
}
