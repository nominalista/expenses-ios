//

import Foundation

struct HomeViewState {
    let transactions: [Transaction]
    let filterDateRange: DateRange
    let filterTags: Set<Tag>
    let currencySummaries: [CurrencySummary]
    let sectionedTransactions: SectionedTransactions

    init(
        transactions: [Transaction] = [],
        filterDateRange: DateRange = .allTime,
        filterTags: Set<Tag> = []
    ) {
        self.transactions = transactions
        self.filterDateRange = filterDateRange
        self.filterTags = filterTags
        
        let filteredTransactions = TransactionFilterHandler(
            filterDateRange: filterDateRange,
            filterTags: filterTags
        ).filter(transactions: transactions)
        
        if !filteredTransactions.isEmpty {
            self.currencySummaries = Dictionary(grouping: filteredTransactions) { $0.currency }
                .map { CurrencySummary(currency: $0, transactions: $1) }
                .sorted(by: { $0.transactionCount > $1.transactionCount })
        } else {
            self.currencySummaries = [.placeholder]
        }
        
        
        self.sectionedTransactions = SectionedTransactions(transactions: filteredTransactions)
    }
    
    func copy(
        transactions: [Transaction]? = nil,
        filterDateRange: DateRange? = nil,
        filterTags: Set<Tag>? = nil
    ) -> HomeViewState {
        HomeViewState(
            transactions: transactions ?? self.transactions,
            filterDateRange: filterDateRange ?? self.filterDateRange,
            filterTags: filterTags ?? self.filterTags
        )
    }
}

struct SectionedTransactions {
    let transactionsByDate: [Date: [Transaction]]
    let sortedDates: [Date]
    
    init(transactions: [Transaction]) {
        self.transactionsByDate = Dictionary(grouping: transactions) { $0.date.startOfDay! }
        self.sortedDates = transactionsByDate.keys.sorted(by: >)
    }
}

struct CurrencySummary {
    var currency: Currency
    var balance: Double
    var transactionCount: Int
    
    static var placeholder: CurrencySummary {
        CurrencySummary(currency: .USD, balance: 0.0, transactionCount: 0)
    }
    
    init(currency: Currency, transactions: [Transaction]) {
        self.currency = currency
        self.balance = transactions.reduce(0.0) { $0 + $1.signedAmount }
        self.transactionCount = transactions.count
    }
    
    init(currency: Currency, balance: Double, transactionCount: Int)  {
        self.currency = currency
        self.balance = balance
        self.transactionCount = transactionCount
    }
}
