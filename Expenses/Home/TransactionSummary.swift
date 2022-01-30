//
//  TransactionSummary.swift
//  Expenses
//
//  Created by Nominalista on 16/01/2022.
//

import Foundation

struct TransactionSummary {
        
    var currencySummaries: [CurrencySummary]
    
    var isEmpty: Bool {
        currencySummaries.isEmpty
    }
    
    init(transactions: [Transaction] = []) {
        self.currencySummaries = Dictionary(grouping: transactions) { $0.currency }
            .map { currency, transactions in
                CurrencySummary(
                    currency: currency,
                    balance: transactions.reduce(0.0) { $0 + $1.signedAmount },
                    transactionCount: transactions.count
                )
            }
            .sorted(by: { $0.transactionCount > $1.transactionCount })
    }
}

struct CurrencySummary {
    var currency: Currency
    var balance: Double
    var transactionCount: Int
}
