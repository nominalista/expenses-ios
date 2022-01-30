//
//  Transaction+NumberFormatter.swift
//  Expenses
//
//  Created by Nominalista on 04/12/2021.
//

import Foundation

extension Transaction {
    
    static func formatter(for currency: Currency?) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency?.code ?? ""
        formatter.currencySymbol = currency?.symbol ?? ""
        return formatter
    }
    
    var plusMinusSign: String {
        switch type {
        case .income:
            return "+"
        case .expense:
            return "-"
        }
    }

    var formattedAmount: String {
        Transaction.formatter(for: currency).string(from: amount as NSNumber) ?? "0"
    }
    
    var formattedSignedAmount: String {
        plusMinusSign + formattedAmount
    }
    
    var formattedAmountWithoutCurrency: String {
        Transaction
            .formatter(for: nil)
            .string(from: amount as NSNumber)?
            .trimmingCharacters(in: .whitespaces) ?? "0"
    }
    
    var formattedSignedAmountWithoutCurrency: String {
        plusMinusSign + formattedAmountWithoutCurrency
    }
    
    var formattedTags: String {
        tags.map { $0.name }.sorted(by: <).joined(separator: ", ")
    }
}
