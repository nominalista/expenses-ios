//
//  ContributorsRow.swift
//  Expenses
//
//  Created by Nominalista on 23/01/2022.
//

import SwiftUI

struct ContributorsRow: View {
    
    var contributors: [Wallet.User]
    var addContributor: (Wallet.User) -> Void
    var updateContributor: (Wallet.User) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer().frame(width: 8)
                Text("Contributors")
                    .font(.subheadline)
                    .foregroundColor(.secondaryLabel)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    Spacer().frame(width: 8)
                    ForEach(contributors, id: \.id) { contributor in
                        ContributorCell(
                            contributor: contributor,
                            updateContributor: updateContributor
                        )
                    }
                    AddContributorCell(addContributor: addContributor)
                    Spacer().frame(width: 8)
                }
                .frame(height: 120)
            }
            .background(Color.secondarySystemGroupedBackground)
            .cornerRadius(8)
        }
        .listRowInsets(EdgeInsets(vertical: 8, horizontal: 0))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

struct ContributorsRow_Previews: PreviewProvider {
    
    static var previews: some View {
        ContributorsRow(
            contributors: [.johnDoe, .emmaMiller, .richardRoger],
            addContributor: { _ in },
            updateContributor: { _ in }
        ).previewLayout(.sizeThatFits)
    }
}

struct ContributorCell: View {
    
    var contributor: Wallet.User
    var updateContributor: (Wallet.User) -> Void
    
    @State var isAddEditContributorLinkActive = false
    
    var body: some View {
        NavigationLink {
            LazyView {
                let viewModel = AddEditContributorViewModel(
                    contributor: contributor,
                    completion: updateContributor
                )
                AddEditContributorView(viewModel: viewModel)
            }
        } label: {
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
}

struct ContributorCell_Previews: PreviewProvider {
    
    static var previews: some View {
        ContributorCell(contributor: .johnDoe) { _ in }
            .previewLayout(.sizeThatFits)
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

struct AddContributorCell: View {
    
    var addContributor: (Wallet.User) -> Void
    
    @State var isAddEditContributorLinkActive = false
    
    var body: some View {
        NavigationLink {
            LazyView {
                let viewModel = AddEditContributorViewModel(
                    contributor: nil,
                    completion: addContributor
                )
                AddEditContributorView(viewModel: viewModel)
            }
        } label: {
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
        .onTapGesture {
            isAddEditContributorLinkActive.toggle()
        }
    }
}

struct AddContributorCell_Previews: PreviewProvider {
    
    static var previews: some View {
        AddContributorCell { _ in }
            .previewLayout(.sizeThatFits)
    }
}
