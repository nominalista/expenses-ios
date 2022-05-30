//
//  CurrenciesView.swift
//  Expenses
//
//  Created by Nominalista on 20/12/2021.
//

import SwiftUI

struct CurrenciesView: View {
    
    @StateObject var viewModel: CurrenciesViewModel
    
    @Environment(\.dismiss) var dismiss

    var didSelectCurrency: (Currency) -> Void
        
    var body: some View {
        List {
            HStack(spacing: 16) {
                Image.icSearch24pt
                    .foregroundColor(.tertiaryLabel)
                
                ModifiableTextField($viewModel.query)
                    .placeholder("Search")
                    .insets(EdgeInsets(vertical: 16, horizontal: 0))
                    .autocapitalizationType(.none)
                    .backgroundColor(.clear)
            }
            
            ForEach(viewModel.currencies, id: \.rawValue) { currency in
                HStack(spacing: 16) {
                    Text(currency.flag)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(currency.code)
                            .font(.body)
                            .foregroundColor(.label)
                        Text(currency.name)
                            .font(.subheadline)
                            .foregroundColor(.secondaryLabel)
                            .lineLimit(1)
                    }
                }
                .padding(.vertical, 8)
                .onTapGesture {
                    didSelectCurrency(currency)
                    dismiss()
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Select currency")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image.icArrowBack24pt
                }
                .buttonStyle(.toolbarIcon)
            }
        }
    }
}

struct CurrenciesView_Previews: PreviewProvider {
    
    static var previews: some View {
        CurrenciesView(viewModel: CurrenciesViewModel()) { _ in }
    }
}
