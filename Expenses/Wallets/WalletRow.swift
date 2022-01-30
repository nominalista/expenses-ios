//
//  WalletRow.swift
//  Expenses
//
//  Created by Nominalista on 23/01/2022.
//

import SwiftUI

struct WalletRow: View {

    var wallet: Wallet
    var isSelected: Bool
    var didSelect: () -> Void
        
    @State private var isWalletLinkActive = false
    
    private var isShared: Bool {
        wallet.contributors.count > 1
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Button {
                didSelect()
            } label: {
                HStack(spacing: 16) {
                    selectionImage
                    emojiImage
                    labelStack
                    Spacer()
                }
            }
            
            editButton
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .listRowInsets(EdgeInsets())
    }
    
    private var selectionImage: some View {
        let imageName = isSelected ? "checkmark.circle.fill" : "circle"
        let imageColor: Color = isSelected ? .brandPrimary : .secondaryLabel
        return Image(systemName: imageName)
            .font(.system(.body).weight(.semibold))
            .frame(width: 24, height: 24, alignment: .center)
            .foregroundColor(imageColor)
    }
    
    private var emojiImage: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.tertiarySystemGroupedBackground)
                .cornerRadius(8)
            Text(wallet.emoji)
                .font(.largeTitle)
        }
        .frame(width: 48, height: 48)
    }
    
    private var labelStack: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(wallet.name)
                .font(.headline)
                .foregroundColor(Color.label)
            
            Text(isShared ? "Shared" : "Private")
                .font(.subheadline)
                .foregroundColor(Color.secondaryLabel)
        }
    }
    
    private var editButton: some View {
        ZStack {
            NavigationLink(isActive: $isWalletLinkActive) {
                LazyView {
                    let viewModel = WalletDetailViewModel(
                        walletRepository: FirebaseWalletRepository.shared,
                        transactionRepository: FirebaseTransactionRepository.shared,
                        wallet: wallet
                    )
                    WalletDetailView(viewModel: viewModel)
                }
            } label: {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            .hidden()
            
            Text("Edit")
                .font(.headline)
                .foregroundColor(.brandPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .background(Color.tertiarySystemGroupedBackground)
                .clipShape(Capsule())
        }
        .onTapGesture {
            isWalletLinkActive.toggle()
        }
    }
}

struct WalletRowPreviews: PreviewProvider {

    static var previews: some View {
        Group {
            WalletRow(wallet: .myWallet, isSelected: true) {}
            WalletRow(wallet: .home, isSelected: false) {}
            WalletRow(wallet: .trip, isSelected: false) {}
        }
        .previewLayout(.sizeThatFits)
    }
}
