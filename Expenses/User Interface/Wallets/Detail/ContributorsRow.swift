//
//  ContributorsRow.swift
//  Expenses
//
//  Created by Nominalista on 23/01/2022.
//

import SwiftUI

struct ContributorsRow: View {
        
    @EnvironmentObject var viewModel: WalletDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer().frame(width: 8)
                Text("Contributors")
                    .font(.subheadline)
                    .foregroundColor(.secondaryLabel)
            }
            contributorCollection
        }
        .listRowInsets(EdgeInsets(vertical: 8, horizontal: 0))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    private var contributorCollection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                Spacer().frame(width: 8)
                ForEach(viewModel.contributors) { contributor in
                    ContributorCell(contributor: contributor)
                }
                
                if viewModel.isEditable {
                    AddContributorCell()
                }
                
                Spacer().frame(width: 8)
            }
            .frame(height: 120)
        }
        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(8)
    }
}

struct ContributorsRow_Previews: PreviewProvider {
    
    static var previews: some View {
        ContributorsRow()
            .environmentObject(WalletDetailViewModel.preview(for: .home))
            .previewLayout(.sizeThatFits)
    }
}
