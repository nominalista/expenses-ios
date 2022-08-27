//
//  HomeSummaryRow.swift
//  Expenses
//
//  Created by Nominalista on 29/01/2022.
//

import SwiftUI

struct HomeSummaryRow: View {
    
    var selectedWallet: Wallet?
    var currencySummaries: [CurrencySummary]
    
    @State var isWalletsViewPresented: Bool = false
 
    var body: some View {        
        VStack(spacing: 16) {
            VStack {
                if !currencySummaries.isEmpty {
                    tabView
                }
            }
            .frame(height: 110)
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
        .listRowBackground(Color.clear)
        .listRowInsets(.zero)
        .sheet(isPresented: $isWalletsViewPresented) {
            walletsView
        }
    }
    
    private var walletButton: some View {
        Button {
            isWalletsViewPresented.toggle()
        } label: {
            HStack(spacing: 0) {
                Spacer().frame(width: 8)
                Text(selectedWallet?.name ?? "Select wallet")
                    .font(.body.weight(.medium))
                    .environment(\.colorScheme, .light)
                    .foregroundColor(.label)
                Image.icArrowDropDown24pt
                    .foregroundColor(Color.separator)
            }
        }
        .buttonStyle(WalletButtonStyle())
    }
    
    private var tabView: some View {
        TabView {
            ForEach(currencySummaries, id: \.currency) {
                CurrencySummaryView(currencySummary: $0)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .environment(\.colorScheme, .dark)
    }
    
    private var walletsView: some View {
        LazyView {
            let viewModel = WalletsViewModel(walletRepository: FirebaseWalletRepository.shared)
            WalletsView(viewModel: viewModel)
        }
    }
}

struct HomeSummaryRow_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            HomeSummaryRow(selectedWallet: nil, currencySummaries: [])
            HomeSummaryRow(selectedWallet: .myWallet, currencySummaries: [.placeholder, .placeholder])
        }
        .previewLayout(.sizeThatFits)
    }
}
    
struct CurrencySummaryView: View {

    var currencySummary: CurrencySummary

    private var formattedBalance: String {
        Transaction
            .formatter(for: currencySummary.currency)
            .string(from: currencySummary.balance as NSNumber) ?? ""
    }

    private var formattedCurrency: String {
        "(\(currencySummary.currency.name) • \(currencySummary.currency.code))"
    }

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Spacer()
                VStack(alignment: .center, spacing: 0) {
                    Text(formattedBalance)
                        .font(.largeTitle.weight(.bold))
                    Text(formattedCurrency)
                        .font(.subheadline)
                        .foregroundColor(.secondaryLabel)
                }
                Spacer()
            }
            Spacer()
        }
    }
}

struct CurrencySummaryView_Previews: PreviewProvider {

    static var previews: some View {
        let currencySummary = CurrencySummary(currency: .USD, balance: 100, transactionCount: 1)
        CurrencySummaryView(currencySummary: currencySummary)
            .previewLayout(.sizeThatFits)
            .frame(maxHeight: 100)
    }
}
