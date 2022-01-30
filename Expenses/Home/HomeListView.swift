//
//  HomeListView.swift
//  Expenses
//
//  Created by Nominalista on 29/01/2022.
//

import SwiftUI

struct HomeListView: View {
    
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        List {
            HomeSummaryRow(
                selectedWallet: viewModel.selectedWallet,
                transactionSummary: viewModel.transactionSummary
            )

            ForEach(viewModel.sectionedTransactions.sortedDates, id: \.self) { date in
                Section(header: Text(date.readableString)) {
                    let transactions = viewModel.sectionedTransactions.transactionsByDate[date] ?? []
                    ForEach(transactions, id: \.id) { transaction in
                        NavigationLink {
                            LazyView {
                                let viewModel = TransactionDetailViewModel(
                                    walletRepostiory: FirebaseWalletRepository.shared,
                                    transactionRepository: FirebaseTransactionRepository.shared,
                                    transaction: transaction
                                )
                                TransactionDetailView(viewModel: viewModel)
                            }
                        } label: {
                            TransactionRow(transaction: transaction)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

struct HomeListView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = HomeViewModel(
            walletRepository: FakeWalletRepostiory(),
            transactionRepostiory: FakeTransactionRepository()
        )
        HomeListView(viewModel: viewModel)
    }
}

extension Date {
    
    var readableString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM"
        return dateFormatter.string(from: self)
    }
}
