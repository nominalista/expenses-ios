//
//  TransactionDetailView.swift
//  Expenses
//
//  Created by Nominalista on 04/12/2021.
//

import Foundation
import UIKit
import SwiftUI

struct TransactionDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: TransactionDetailViewModel
    
    @State private var isDeleteAlertPresented = false
    @State private var isAddEditViewPresented = false
    
    var body: some View {
        Form {
            amountRow
            titleRow
            tagsRow
            dateRow
            notesRow
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.systemGroupedBackground)
        .sheet(isPresented: $isAddEditViewPresented) {

        } content: {
            let viewModel = AddEditTransactionViewModel(
                transactionRepository: FirebaseTransactionRepository.shared,
                transaction: viewModel.transaction
            )
            AddEditTransactionView(viewModel: viewModel)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(uiImage: #imageLiteral(resourceName: "ic_arrow_back_24pt"))
                        .renderingMode(.template)
                        .foregroundColor(.brandPrimary)
                        .padding(6)
                        .background(Color.systemGray5)
                        .clipShape(Circle())
                }
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    isAddEditViewPresented = true
                } label: {
                    Image(uiImage: #imageLiteral(resourceName: "ic_create_24pt"))
                        .renderingMode(.template)
                        .foregroundColor(.brandPrimary)
                        .padding(6)
                        .background(Color.systemGray5)
                        .clipShape(Circle())
                }
                
                Button {
                    isDeleteAlertPresented = true
                } label: {
                    Image(uiImage: #imageLiteral(resourceName: "ic_delete_24pt"))
                        .renderingMode(.template)
                        .foregroundColor(.brandPrimary)
                        .padding(6)
                        .background(Color.systemGray5)
                        .clipShape(Circle())
                }
                .alert("Delete transaction?", isPresented: $isDeleteAlertPresented) {
                    Button("Delete", role: .destructive) {
                        viewModel.deleteTransaction()
                        dismiss()
                    }
                    Button("Cancel", role: .cancel) {}
                }
            }
        }
    }
    
    private var amountRow: some View {
        HStack(alignment: .center) {
            Spacer()
            VStack(alignment: .center, spacing: 4) {
                Text(viewModel.transaction.formattedSignedAmount)
                    .font(.largeTitle.weight(.bold))
                Text("(\(viewModel.transaction.currency.name) • \(viewModel.transaction.currency.code))")
                    .font(.subheadline)
                    .foregroundColor(.secondaryLabel)
            }
            Spacer()
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    private var titleRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer().frame(width: 8)
                Text("Title")
                    .font(.subheadline)
                    .foregroundColor(.secondaryLabel)
                Spacer()
            }
            
            HStack {
                Text(viewModel.transaction.title)
                Spacer()
            }
            .padding(EdgeInsets(16))
            .background(Color.secondarySystemGroupedBackground)
            .cornerRadius(8)
        }
        .listRowInsets(EdgeInsets(vertical: 8, horizontal: 0))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    private var tagsRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer().frame(width: 8)
                Text("Tags")
                    .font(.subheadline)
                    .foregroundColor(.secondaryLabel)
            }

            HStack {
                if !viewModel.formattedTags.isEmpty {
                    Text(viewModel.formattedTags)
                } else {
                    Text("No tags").foregroundColor(.tertiaryLabel)
                }
                Spacer()
            }
            .padding(EdgeInsets(16))
            .background(Color.secondarySystemGroupedBackground)
            .cornerRadius(8)
        }
        .listRowInsets(EdgeInsets(vertical: 8, horizontal: 0))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    private var dateRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer().frame(width: 8)
                Text("Date")
                    .font(.subheadline)
                    .foregroundColor(.secondaryLabel)
            }
            
            HStack {
                Text(viewModel.formattedDate)
                Spacer()
            }
            .padding(EdgeInsets(16))
            .background(Color.secondarySystemGroupedBackground)
            .cornerRadius(8)
        }
        .listRowInsets(EdgeInsets(vertical: 8, horizontal: 0))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    private var notesRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer().frame(width: 8)
                Text("Notes")
                    .font(.subheadline)
                    .foregroundColor(.secondaryLabel)
            }
            
            HStack {
                if !viewModel.transaction.notes.isEmpty {
                    Text(viewModel.transaction.notes)
                } else {
                    Text("No notes").foregroundColor(.tertiaryLabel)
                }
                Spacer()
            }
            .padding(EdgeInsets(16))
            .background(Color.secondarySystemGroupedBackground)
            .cornerRadius(8)
        }
        .listRowInsets(EdgeInsets(vertical: 8, horizontal: 0))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

struct TransactionDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = TransactionDetailViewModel(
            walletRepostiory: FakeWalletRepostiory(),
            transactionRepository: FakeTransactionRepository(),
            transaction: .example
        )
        TransactionDetailView(viewModel: viewModel)
    }
}
