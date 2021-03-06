//
//  WalletsView.swift
//  Expenses
//
//  Created by Nominalista on 06/01/2022.
//

import SwiftUI

struct WalletsView: View {
    
    @StateObject var viewModel: WalletsViewModel
    
    @Environment(\.dismiss) private var dismiss
        
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    walletsSection
                }
                .listStyle(.insetGrouped)
                
                selectButton
            }
            .navigationTitle("Wallets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarLeadingItem
            }
        }
        .onReceive(viewModel.dismissPublisher) { _ in
            dismiss()
        }
    }
    
    private var walletsSection: some View {
        Section {
            ForEach(viewModel.wallets, id: \.id) { wallet in
                let isSelected = viewModel.selectedWalletID == wallet.id
                WalletRow(wallet: wallet, isSelected: isSelected) {
                    viewModel.select(wallet: wallet)
                }
            }
            AddWalletRow()
        }
    }
    
    private var selectButton: some View {
        VStack {
            Spacer()
            
            Button {
                viewModel.selectAndDismiss()
            } label: {
                HStack {
                    Spacer()
                    Text("Select")
                        .foregroundColor(.label)
                        .font(.headline)
                    Spacer()
                }
            }
            .padding(16)
            .background(Color.brandPrimary)
            .clipShape(Capsule())
            .environment(\.colorScheme, .dark)
        }
        .padding(16)
    }
    
    private var toolbarLeadingItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(uiImage: #imageLiteral(resourceName: "ic_close_24pt"))
                    .renderingMode(.template)
            }
            .buttonStyle(.toolbarIcon)
        }
    }
}

struct WalletsViewPreviews: PreviewProvider {

    static var previews: some View {
        let viewModel = WalletsViewModel(walletRepository: FakeWalletRepostiory())
        Group {
            WalletsView(viewModel: viewModel)
                .preferredColorScheme(.light)
            
            WalletsView(viewModel: viewModel)
                .preferredColorScheme(.dark)
        }
    }
}
