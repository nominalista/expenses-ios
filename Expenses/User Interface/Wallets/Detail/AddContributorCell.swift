//
//  AddContributorCell.swift
//  Expenses
//
//  Created by Nominalista on 08/02/2022.
//

import SwiftUI

struct AddContributorCell: View {
    
    @EnvironmentObject var viewModel: WalletDetailViewModel
        
    var body: some View {
        NavigationLink {
            destination
        } label: {
            content
        }
    }
    
    private var destination: some View {
        LazyView {
            let viewModel = AddEditContributorViewModel(
                contributor: nil,
                didAddEdit: { self.viewModel.add(contributor: $0) },
                didDelete: { _ in }
            )
            AddEditContributorView(viewModel: viewModel)
        }
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .foregroundColor(Color.tertiarySystemGroupedBackground)
                    .frame(width: 64, height: 64)
                Image(systemName: "plus")
                    .font(.system(.headline).weight(.semibold))
                    .foregroundColor(Color.brandPrimary)
            }
            Spacer().frame(height: 8)
            Text("Add")
                .font(.footnote)
                .foregroundColor(.label)
        }
        .padding(8)
        .frame(width: 88, height: 88)
    }
}

struct AddContributorCell_Previews: PreviewProvider {
    
    static var previews: some View {
        AddContributorCell()
            .previewLayout(.sizeThatFits)
    }
}
