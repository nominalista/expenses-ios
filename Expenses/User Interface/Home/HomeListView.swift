//
//  HomeListView.swift
//  Expenses
//
//  Created by Nominalista on 29/01/2022.
//

import SwiftUI
import StoreKit
import UIKit

struct HomeListView: View {
    
    @StateObject var viewModel: HomeViewModel
        
    var body: some View {
        List {
            HomeSummaryRow(
                selectedWallet: viewModel.selectedWallet,
                currencySummaries: viewModel.viewState.currencySummaries
            )
            
            HomeFilterView()
                .listRowInsets(.init(vertical: 16, horizontal: 0))
                .listRowStyle(.plain)

            ForEach(viewModel.viewState.sectionedTransactions.sortedDates, id: \.self) { date in
                Section(header: Text(date.readableString)) {
                    let transactions = viewModel
                        .viewState
                        .sectionedTransactions
                        .transactionsByDate[date] ?? []
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
            .listRowBackground(
                VisualEffectView(effect: UIBlurEffect(style: .systemMaterialLight))
                    .opacity(0.1)
            )
        }
        .listStyle(.insetGrouped)
    }
}

struct HomeListView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = HomeViewModel(
            walletRepository: FakeWalletRepostiory(),
            transactionRepostiory: FakeTransactionRepository(),
            tagRepository: FakeTagRepository(),
            subscriptionManager: SubscriptionManager.shared
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
