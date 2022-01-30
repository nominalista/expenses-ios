//
//  TransactionRow.swift
//  Expenses
//
//  Created by Nominalista on 15/01/2022.
//

import Foundation
import SwiftUI

struct TransactionRow: View {
    
    var transaction: Transaction
    
    var isSelectable: Bool = false
    var isSelected: Bool = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            labelStack
            Spacer()
            amountText
            
            if isSelectable {
                selectionIndicator
            }
        }
        .frame(height: 64)
    }
    
    private var labelStack: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(transaction.title)
                .font(.headline)
                .foregroundColor(.label)
                .lineLimit(1)
            
            if !transaction.tags.isEmpty {
                Spacer().frame(height: 4)
                
                Text(transaction.formattedTags)
                    .font(.subheadline)
                    .foregroundColor(.secondaryLabel)
                    .lineLimit(1)
            }
        }
    }
    
    private var amountText: some View {
        Text(transaction.formattedSignedAmount)
            .font(.headline)
            .foregroundColor(.label)
            .padding(.leading, 16)
    }
    
    private var selectionIndicator: some View {
        HStack {
            Spacer().frame(width: 16)
            Image(systemName: "checkmark")
                .font(.system(.body).weight(.semibold))
                .frame(width: 24, height: 24, alignment: .center)
                .foregroundColor(Color.brandPrimary)
                .if(!isSelected) { $0.hidden() }
        }
    }
}

struct TransactionRowPreviews: PreviewProvider {
    
    static var previews: some View {
        TransactionRow(transaction: .example, isSelectable: true, isSelected: true)
            .previewLayout(.sizeThatFits)
    }
}
