//
//  CurrenciesView.swift
//  Expenses
//
//  Created by Nominalista on 20/12/2021.
//

import SwiftUI

struct CurrenciesView: View {
    
    @Environment(\.dismiss) var dismiss

    var didSelectCurrency: (Currency) -> Void
        
    var body: some View {
        List(Currency.allCases, id: \.rawValue) { currency in
            HStack {
                Text(currency.flag)
                Spacer().frame(width: 16)
                VStack(alignment: .leading) {
                    Text(currency.code).font(.body)
                    Text(currency.name)
                        .font(.subheadline)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                }
            }
            .padding(.vertical, 8)
            .onTapGesture {
                didSelectCurrency(currency)
                dismiss()
            }
        }
        .listStyle(.insetGrouped)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Select currency")
    }
}

struct CurrenciesView_Previews: PreviewProvider {
    
    static var previews: some View {
        CurrenciesView { _ in }
    }
}
