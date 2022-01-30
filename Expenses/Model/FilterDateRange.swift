//
//  FilterDateRange.swift
//  Expenses
//
//  Created by Nominalista on 25/12/2021.
//

import Foundation

enum FilterDateRange: String, CaseIterable {
    
    case allTime
    case today
    case thisWeek
    case thisMonth
    
    func filter(transaction: Transaction) -> Bool {
        switch self {
        case .allTime:
            return true
        case .today:
            return isFromToday(transaction: transaction)
        case .thisWeek:
            return isFromThisWeek(transaction: transaction)
        case .thisMonth:
            return isFromThisMonth(transaction: transaction)
        }
    }
    
    private func isFromToday(transaction: Transaction) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        
        let startOfToday = calendar.startOfDay(for: now)
        guard let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday) else {
            return false
        }
        
        return (startOfToday..<startOfTomorrow).contains(transaction.date)
    }
    
    private func isFromThisWeek(transaction: Transaction) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        
        guard let lastSunday = calendar.dateComponents(
            [.calendar, .yearForWeekOfYear, .weekOfYear],
            from: now
        ).date else {
            return false
        }
        
        guard let lastMonday = calendar.date(byAdding: .day, value: 1, to: lastSunday),
              let nextMonday = calendar.date(byAdding: .weekOfYear, value: 1, to: lastMonday) else {
                  return false
              }
        
        return (lastMonday..<nextMonday).contains(transaction.date)
    }
    
    private func isFromThisMonth(transaction: Transaction) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        
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
}
