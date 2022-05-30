//
//  Exporter.swift
//  Expenses
//
//  Created by Nominalista on 24/12/2021.
//

import Foundation

enum ExportingError: Error {
    case noAccessToDocuments
}

class Exporter {
    
    static func exportToCSV(from transactions: [Transaction]) async throws -> URL {
        var csvString = "Type,Amount,Currency,Title,Date,Notes,Tags\n"
        
        let sortedTransactions: [Transaction] = transactions.sorted(by: { $0.date < $1.date })
        sortedTransactions.forEach { (transaction: Transaction) in
            csvString.append("\"\(transaction.type.rawValue)\",")
            csvString.append("\"\(transaction.formattedAmountWithoutCurrency)\",")
            csvString.append("\"\(transaction.currency.code)\",")
            csvString.append("\"\(transaction.title)\",")
            
            let formattedDate = DateFormatter.exportTransactionDate.string(from: transaction.date)
            csvString.append("\"\(formattedDate)\",")
            csvString.append("\"\(transaction.notes)\",")
            csvString.append("\"\(transaction.formattedTags)\"")
            csvString.append("\n")
        }
        
        let documentDirs = FileManager.default.urls(for: .documentDirectory,in: .allDomainsMask)
        guard let documentDir = documentDirs.first else {
            throw ExportingError.noAccessToDocuments
        }
        
        let fileName = "Expenses-\(DateFormatter.exportFileName.string(from: Date())).csv"
        let fileURL = documentDir.appendingPathComponent(fileName)
        
        try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
        
        return fileURL
    }
}

extension DateFormatter {
    
    class var exportTransactionDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        formatter.timeZone = .current
        return formatter
    }
    
    class var exportFileName: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMddHHmmss"
        formatter.timeZone = .current
        return formatter
    }
}
