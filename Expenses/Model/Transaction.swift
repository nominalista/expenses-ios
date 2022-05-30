//
//  Transaction.swift
//  Expenses
//
//  Created by Nominalista on 04/12/2021.
//

import Foundation

struct Transaction: Identifiable, Hashable, Codable {

    var id: String
    var type: TransactionType
    var currency: Currency
    var amount: Double
    var title: String
    var tags: [Tag]
    var date: Date
    var notes: String
    var timestamp: Int?
    
    var signedAmount: Double {
        switch type {
        case .income:
            return amount
        case .expense:
            return -amount
        }
    }
    
    init(
        id: String = UUID().uuidString,
        type: TransactionType,
        amount: Double,
        currency: Currency,
        title: String,
        tags: [Tag],
        date: Date,
        notes: String,
        timestamp: Int? = nil
    ) {
        self.id = id
        self.type = type
        self.amount = amount
        self.currency = currency
        self.title = title
        self.tags = tags
        self.date = date
        self.notes = notes
        self.timestamp = timestamp
    }
}

enum TransactionType: String, Codable {
    case income
    case expense
}
