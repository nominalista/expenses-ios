//
//  TransactionFilterHandlerTests.swift
//  ExpensesTests
//
//  Created by Nominalista on 12/02/2022.
//

import XCTest
@testable import Expenses

class TransactionFilterHandlerTests: XCTestCase {
    
    class MockTransactionFilterHandler: TransactionFilterHandler {
        
        override var now: Date { .init(isoDate: "2022-02-01T12:00:00+0000")! }
        
        override var calendar: Calendar {
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(abbreviation: "UTC")!
            return calendar
        }
        
        init(filterDateRange: DateRange) {
            super.init(filterDateRange: filterDateRange, filterTags: [])
        }
    }
    
    func testAllTime() throws {
        let handler = MockTransactionFilterHandler(filterDateRange: .allTime)
        XCTAssertTrue(handler.filter(transaction: .fakeFromTomorrow))
        XCTAssertTrue(handler.filter(transaction: .fakeFromToday))
        XCTAssertTrue(handler.filter(transaction: .fakeFromYesterday))
        XCTAssertTrue(handler.filter(transaction: .fakeFromWeekAgo))
        XCTAssertTrue(handler.filter(transaction: .fakeFromMonthAgo))
        XCTAssertTrue(handler.filter(transaction: .fakeFromYearAgo))
    }
    
    func testToday() throws {
        let handler = MockTransactionFilterHandler(filterDateRange: .today)
        XCTAssertFalse(handler.filter(transaction: .fakeFromTomorrow))
        XCTAssertTrue(handler.filter(transaction: .fakeFromToday))
        XCTAssertFalse(handler.filter(transaction: .fakeFromYesterday))
        XCTAssertFalse(handler.filter(transaction: .fakeFromWeekAgo))
        XCTAssertFalse(handler.filter(transaction: .fakeFromMonthAgo))
        XCTAssertFalse(handler.filter(transaction: .fakeFromYearAgo))
    }
    
    func testThisWeek() throws {
        let handler = MockTransactionFilterHandler(filterDateRange: .thisWeek)
        XCTAssertTrue(handler.filter(transaction: .fakeFromTomorrow))
        XCTAssertTrue(handler.filter(transaction: .fakeFromToday))
        XCTAssertTrue(handler.filter(transaction: .fakeFromYesterday))
        XCTAssertFalse(handler.filter(transaction: .fakeFromWeekAgo))
        XCTAssertFalse(handler.filter(transaction: .fakeFromMonthAgo))
        XCTAssertFalse(handler.filter(transaction: .fakeFromYearAgo))
    }
    
    func testThisMonth() throws {
        let handler = MockTransactionFilterHandler(filterDateRange: .thisMonth)
        XCTAssertTrue(handler.filter(transaction: .fakeFromTomorrow))
        XCTAssertTrue(handler.filter(transaction: .fakeFromToday))
        XCTAssertFalse(handler.filter(transaction: .fakeFromYesterday))
        XCTAssertFalse(handler.filter(transaction: .fakeFromWeekAgo))
        XCTAssertFalse(handler.filter(transaction: .fakeFromMonthAgo))
        XCTAssertFalse(handler.filter(transaction: .fakeFromYearAgo))
    }
    
    func testCustom() throws {
        let filterDateRange: DateRange = .custom(
            Transaction.fakeFromMonthAgo.date,
            Transaction.fakeFromToday.date
        )
        let handler = MockTransactionFilterHandler(filterDateRange: filterDateRange)
        XCTAssertFalse(handler.filter(transaction: .fakeFromTomorrow))
        XCTAssertTrue(handler.filter(transaction: .fakeFromToday))
        XCTAssertTrue(handler.filter(transaction: .fakeFromYesterday))
        XCTAssertTrue(handler.filter(transaction: .fakeFromWeekAgo))
        XCTAssertTrue(handler.filter(transaction: .fakeFromMonthAgo))
        XCTAssertFalse(handler.filter(transaction: .fakeFromYearAgo))
    }
}

private extension Transaction {
    
    static var fakeFromTomorrow: Transaction {
        .init(date: Date(isoDate: "2022-02-02T00:00:00+0000")!)
    }
    
    static var fakeFromToday: Transaction {
        .init(date: Date(isoDate: "2022-02-01T00:00:00+0000")!)
    }
    
    static var fakeFromYesterday: Transaction {
        .init(date: Date(isoDate: "2022-01-31T00:00:00+0000")!)
    }
    
    static var fakeFromWeekAgo: Transaction {
        .init(date: Date(isoDate: "2022-01-25T00:00:00+0000")!)
    }
    
    static var fakeFromMonthAgo: Transaction {
        .init(date: Date(isoDate: "2022-01-01T00:00:00+0000")!)
    }
    
    static var fakeFromYearAgo: Transaction {
        .init(date: Date(isoDate: "2021-02-01T00:00:00+0000")!)
    }
    
    private init(date: Date) {
        self.init(
            id: UUID().uuidString,
            type: .expense,
            amount: 0,
            currency: .USD,
            title: "",
            tags: [],
            date: date,
            notes: "",
            timestamp: nil
        )
    }
}

private extension Date {
    
    init?(isoDate: String) {
        if let date = ISO8601DateFormatter().date(from: isoDate) {
            self.init(millis: date.millisSince1970)
        } else {
            return nil
        }
    }
}
