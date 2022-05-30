//
//  Date+Millis.swift
//  Expenses
//
//  Created by Nominalista on 12/12/2021.
//

import Foundation

extension Date {
    
    var millisSince1970: Int {
        Int((timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(millis: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(millis / 1000))
    }
}

extension Date {
    
    var startOfDay: Date? {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .second, value: -1, to: self)
    }
}
