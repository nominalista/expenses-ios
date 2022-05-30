//
//  Importer.swift
//  Expenses
//
//  Created by Nominalista on 10/01/2022.
//

import Foundation
import TabularData

class Importer {
    
    private let expectedNumberOfColumns = 7
    
    private let typeColumnIndex = 0
    private let amountColumnIndex = 1
    private let currencyColumnIndex = 2
    private let titleColumnIndex = 3
    private let dateColumnIndex = 4
    private let notesColumnIndex = 5
    private let tagsColumnIndex = 6
    
    private let transactionRepository: TransactionRepository
    private let tagRepository: TagRepository
    
    init(transactionRepository: TransactionRepository, tagRepository: TagRepository) {
        self.transactionRepository = transactionRepository
        self.tagRepository = tagRepository
    }

    func importTransactions(
        from url: URL,
        toWalletWithID walletID: String
    ) async -> Result<Void, Error> {
        do {
            let transactions = try importTransactions(from: url)
            try await insert(transactions: transactions, toWalletWithID: walletID)
            
            return .success(())
        } catch let error {
            return .failure(error)
        }
    }
}

// MARK: - CSV import

extension Importer {
    
    private func importTransactions(from url: URL) throws -> [Transaction] {
        guard url.startAccessingSecurityScopedResource() else {
            throw ImportError.fileAccessForbidden
        }
        
        let dataFrame = try makeCSVDataFrame(from: url)
        let transactions = try extractTransactions(from: dataFrame)
        
        url.stopAccessingSecurityScopedResource()
        
        return transactions
    }
    
    private func makeCSVDataFrame(from fileURL: URL) throws -> DataFrame {
        do {
            return try DataFrame(contentsOfCSVFile: fileURL)
        } catch let error {
            throw ImportError.invalidFormat(error)
        }
    }
    
    private func extractTransactions(from dataFrame: DataFrame) throws -> [Transaction] {
        try dataFrame.rows.map { try makeTransaction(from: $0) }
    }
    
    private func makeTransaction(from row: DataFrame.Row) throws -> Transaction {
        guard row.count == expectedNumberOfColumns else {
            throw ImportError.invalidNumberOfColumns(getNaturalRowIndex(of: row))
        }
        
        let type = try getType(from: row)
        let amount = try getAmount(from: row)
        let currency = try getCurrency(from: row)
        let title = try getTitle(from: row)
        let date = try getDate(from: row)
        let notes = try getNotes(from: row)
        let tags = try getTags(from: row)
        
        return Transaction(
            type: type,
            amount: amount,
            currency: currency,
            title: title,
            tags: tags,
            date: date,
            notes: notes
        )
    }
    
    private func getType(from row: DataFrame.Row) throws -> TransactionType {
        guard let typeRawValue = try getStringElement(from: row, at: typeColumnIndex) else {
            throw ImportError.invalidType(nil, getNaturalRowIndex(of: row))
        }
        
        guard let type = TransactionType(rawValue: typeRawValue) else {
            throw ImportError.invalidType(typeRawValue, getNaturalRowIndex(of: row))
        }
        
        return type
    }
    
    private func getAmount(from row: DataFrame.Row) throws -> Double {
        guard let formattedAmount = try getStringElement(from: row, at: amountColumnIndex) else {
            throw ImportError.invalidAmount(nil, getNaturalRowIndex(of: row))
        }
        
        guard let number = Transaction.formatter(for: nil).number(from: formattedAmount) else {
            throw ImportError.invalidAmount(formattedAmount, getNaturalRowIndex(of: row))
        }
        
        return abs(Double(truncating: number))
    }
    
    private func getCurrency(from row: DataFrame.Row) throws -> Currency {
        guard let currencyCode = try getStringElement(from: row, at: currencyColumnIndex) else {
            throw ImportError.invalidCurrency(nil, getNaturalRowIndex(of: row))
        }

        guard let currency = Currency(rawValue: currencyCode) else {
            throw ImportError.invalidCurrency(currencyCode, getNaturalRowIndex(of: row))
        }
        
        return currency
    }
    
    private func getTitle(from row: DataFrame.Row) throws -> String {
        try getStringElement(from: row, at: titleColumnIndex) ?? ""
    }
    
    private func getDate(from row: DataFrame.Row) throws -> Date {
        guard let formattedDate = try getStringElement(from: row, at: dateColumnIndex) else {
            throw ImportError.invalidDate(nil, getNaturalRowIndex(of: row))
        }
        
        guard let date = DateFormatter.exportTransactionDate.date(from: formattedDate) else {
            throw ImportError.invalidDate(formattedDate, getNaturalRowIndex(of: row))
        }
        
        return date
    }
    
    private func getNotes(from row: DataFrame.Row) throws -> String {
        try getStringElement(from: row, at: notesColumnIndex) ?? ""
    }
    
    private func getTags(from row: DataFrame.Row) throws -> [Tag] {
        guard let formattedTagNames = try getStringElement(from: row, at: tagsColumnIndex) else {
            return []
        }
        
        return formattedTagNames.components(separatedBy: ", ")
            .filter { !$0.isBlank }
            .map { Tag(name: $0) }
    }
    
    // Accessing row element
    
    private func getStringElement(from row: DataFrame.Row, at columnIndex: Int) throws -> String? {
        guard let element = row[columnIndex] else {
            return nil
        }
        
        guard let string = element as? String else {
            throw ImportError.invalidCellType(getNaturalRowIndex(of: row), columnIndex)
        }
        
        return string
    }
    
    // Indices
    
    private func getNaturalRowIndex(of row: DataFrame.Row) -> Int {
        row.index + 1 /* indices start from 0 */ + 1 /* header row */
    }
    
    private func getNaturalColumnIndex(of column: Int) -> Int {
        column + 1 /* indices start from 0 */
    }
}

// MARK: - Transactions insertion

extension Importer {
    
    private func insert(
        transactions: [Transaction],
        toWalletWithID walletID: String
    ) async throws {
        var existingTagsByName = try await getExistingTagsByName(forWalletWithID: walletID)
        
        for transaction in transactions {
            var existingTransactionTags = [Tag]()
            
            for tag in transaction.tags {
                if let existingTag = existingTagsByName[tag.name] {
                    existingTransactionTags.append(existingTag)
                } else {
                    let newTag = insert(tag: tag, toWalletWithID: walletID)
                    existingTagsByName[tag.name] = newTag
                    existingTransactionTags.append(newTag)
                }
            }
            
            var updatedTransaction = transaction
            updatedTransaction.tags = existingTransactionTags
            let _ = transactionRepository.insert(transaction: transaction, toWalletWithID: walletID)
        }
    }
    
    private func getExistingTagsByName(
        forWalletWithID walletID: String
    ) async throws -> [String: Tag] {
        let tags = try await tagRepository.getTags(forWalletWithID: walletID).get()
        return tags.reduce(into: [String: Tag]()) { $0[$1.name] = $1 }
    }
    
    private func insert(tag: Tag, toWalletWithID walletID: String) -> Tag {
        tagRepository.insert(tag: tag, toWalletWithID: walletID)
    }
}
