//
//  ContributorCell.swift
//  Expenses
//
//  Created by Nominalista on 08/02/2022.
//

import SwiftUI

struct ContributorCell: View {
    
    var contributor: Wallet.User
    
    @EnvironmentObject var viewModel: WalletDetailViewModel
    
    var body: some View {
        NavigationLink {
            destination
        } label: {
            content
        }
        .disabled(!viewModel.isEditable)
    }
    
    private var destination: some View {
        LazyView {
            let viewModel = AddEditContributorViewModel(
                contributor: contributor,
                didAddEdit: { self.viewModel.update(contributor: $0) },
                didDelete: { self.viewModel.delete(contributor: $0) }
            )
            AddEditContributorView(viewModel: viewModel)
        }
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .foregroundColor(Color.brandPrimary)
                    .frame(width: 64, height: 64)
                Text(contributor.initials)
                    .font(.title).fontWeight(.bold)
                    .foregroundColor(Color.label)
                    .environment(\.colorScheme, .dark)
            }
            Spacer().frame(height: 8)
            Text(contributor.name)
                .font(.footnote)
                .foregroundColor(.label)
                .lineLimit(1)
        }
        .padding(8)
        .frame(width: 88, height: 88)
    }
}

private extension Wallet.User {

    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        formatter.style = .abbreviated
        
        guard let components = formatter.personNameComponents(from: name) else { return "" }
        return formatter.string(from: components)
    }
}

struct ContributorCell_Previews: PreviewProvider {
    
    static var previews: some View {
        let wallet = Wallet.home
        ContributorCell(contributor: wallet.contributors.first!)
            .environmentObject(WalletDetailViewModel.preview(for: wallet))
            .previewLayout(.sizeThatFits)
    }
}
