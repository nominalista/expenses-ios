//
//  SectionedTransactions.swift
//  Expenses
//
//  Created by Nominalista on 15/01/2022.
//

import Foundation

struct SectionedTransactions {
    
    var transactionsByDate: [Date: [Transaction]]
    var sortedDates: [Date]
    
    init(transactions: [Transaction] = []) {
        self.transactionsByDate = Dictionary(grouping: transactions) { $0.date.startOfDay! }
        self.sortedDates = transactionsByDate.keys.sorted(by: >)
    }
}
