//
//  DateRange.swift
//  Expenses
//
//  Created by Nominalista on 25/12/2021.
//

import Foundation

enum DateRange: Equatable {
    
    case allTime
    case today
    case thisWeek
    case thisMonth
    case custom(Date, Date)
}
