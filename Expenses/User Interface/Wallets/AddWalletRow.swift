//
//  AddWalletRow.swift
//  Expenses
//
//  Created by Nominalista on 23/01/2022.
//

import SwiftUI

struct AddWalletRow: View {
    
    @State private var isWalletLinkActive = false
    @State private var isExpensesPlusSheetPresented = false
    
    var body: some View {
        ZStack {
            NavigationLink(isActive: $isWalletLinkActive) {
                LazyView {
                    let viewModel = WalletDetailViewModel(
                        walletRepository: FirebaseWalletRepository.shared,
                        transactionRepository: FirebaseTransactionRepository.shared,
                        tagRepository: FirebaseTagRepository.shared,
                        wallet: nil
                    )
                    WalletDetailView(viewModel: viewModel)
                }
            } label: {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            .hidden()
            
            HStack(spacing: 8) {
                Spacer()
                Image(systemName: "plus")
                    .font(.system(.body).weight(.semibold))
                    .frame(width: 24, height: 24, alignment: .center)
                Text("Add wallet")
                    .font(.headline)
                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .foregroundColor(.brandPrimary)
        }
        .listRowInsets(EdgeInsets())
        .sheet(isPresented: $isExpensesPlusSheetPresented) {
            LazyView {
                ExpensesPlusView()
            }
        }
        .onTapGesture {
            // isWalletLinkActive.toggle()
            isExpensesPlusSheetPresented.toggle()
        }
    }
}

struct AddWalletRowPreviews: PreviewProvider {
    
    static var previews: some View {
        AddWalletRow()
            .previewLayout(.sizeThatFits)
    }
}
