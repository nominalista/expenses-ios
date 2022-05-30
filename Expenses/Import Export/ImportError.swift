//
//  ImportError.swift
//  Expenses
//
//  Created by Nominalista on 16/01/2022.
//

import Foundation

enum ImportError: Error {
    case fileAccessForbidden
    case invalidFormat(Error)
    case invalidNumberOfColumns(Int)
    case invalidCellType(Int, Int)
    case invalidType(String?, Int)
    case invalidAmount(String?, Int)
    case invalidCurrency(String?, Int)
    case invalidDate(String?, Int)
}

class ImportErrorHandler {
    
    static func handle(error: Error) -> String {
        guard let error = error as? ImportError else {
            return "Unexpected error has occurred."
        }
        
        switch error {
        case .fileAccessForbidden:
            return "Cannot access file."
        case .invalidFormat(let childError):
            return "File has invalid format (\(childError.localizedDescription))."
        case .invalidNumberOfColumns(let row):
            return "Row \(row) has invalid number of columns."
        case .invalidCellType(let row, let column):
            return "Cell (\(row), \(column)) has invalid type."
        case .invalidType(let value, let row):
            return "Row \(row) has invalid type (\(value ?? "null"))."
        case .invalidAmount(let value, let row):
            return "Row \(row) has invalid amount (\(value ?? "null"))."
        case .invalidCurrency(let value, let row):
            return "Row \(row) has invalid currency (\(value ?? "null"))."
        case .invalidDate(let value, let row):
            return "Row \(row) has invalid date (\(value ?? "null"))."
        }
    }
}
