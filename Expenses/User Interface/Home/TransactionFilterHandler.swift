//
//  TransactionFilterHandler.swift
//  Expenses
//
//  Created by Nominalista on 12/02/2022.
//

import Foundation

class TransactionFilterHandler {
    
    private let filterDataRange: DateRange
    private let filterTags: Set<Tag>
    
    var now: Date { .now }
    
    var calendar: Calendar { .current }
    
    init(filterDateRange: DateRange, filterTags: Set<Tag>) {
        self.filterDataRange = filterDateRange
        self.filterTags = filterTags
    }
    
    func filter(transactions: [Transaction]) -> [Transaction] {
        transactions.filter { filter(transaction: $0) }
    }
    
    func filter(transaction: Transaction) -> Bool {
        filterByDateRange(transaction: transaction) && filterByTags(transaction: transaction)
    }
    
    private func filterByDateRange(transaction: Transaction) -> Bool {
        switch filterDataRange {
        case .allTime:
            return true
        case .today:
            return isFromToday(transaction: transaction)
        case .thisWeek:
            return isFromThisWeek(transaction: transaction)
        case .thisMonth:
            return isFromThisMonth(transaction: transaction)
        case .custom(let start, let end):
            return isWithinDateRange(transaction: transaction, start: start, end: end)
        }
    }
    
    private func isFromToday(transaction: Transaction) -> Bool {
        let startOfToday = calendar.startOfDay(for: now)
        guard let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday) else {
            return false
        }
        
        return (startOfToday..<startOfTomorrow).contains(transaction.date)
    }
    
    private func isFromThisWeek(transaction: Transaction) -> Bool {
        guard let lastMonday = calendar.dateComponents(
            [.calendar, .yearForWeekOfYear, .weekOfYear],
            from: now
        ).date else {
            return false
        }
        
        guard let nextMonday = calendar.date(byAdding: .weekOfYear, value: 1, to: lastMonday) else {
            return false
        }

        return (lastMonday..<nextMonday).contains(transaction.date)
    }
    
    private func isFromThisMonth(transaction: Transaction) -> Bool {
        guard let startOfCurrentMonth = calendar.dateComponents(
            [.calendar, .year, .month],
            from: now
        ).date else {
            return false
        }
        guard let startOfNextMonth = calendar.date(
            byAdding: .month,
            value: 1,
            to: startOfCurrentMonth
        ) else {
            return false
        }
        
        return (startOfCurrentMonth..<startOfNextMonth).contains(transaction.date)
    }
    
    private func isWithinDateRange(transaction: Transaction, start: Date, end: Date) -> Bool {
        (start...end).contains(transaction.date)
    }
    
    private func filterByTags(transaction: Transaction) -> Bool {
        guard !filterTags.isEmpty else { return true }
        return transaction.tags.contains(where: { filterTags.contains($0) })
    }
}
