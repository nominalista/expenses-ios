//
//  AddEditContributorView.swift
//  Expenses
//
//  Created by Nominalista on 08/01/2022.
//

import SwiftUI

struct AddEditContributorView: View {
    
    @StateObject var viewModel: AddEditContributorViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            nameRow
            shareIDRow
        }
        .listStyle(.plain)
        .background(Color.systemGroupedBackground)
        .navigationTitle("Add contributor")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(.body).weight(.semibold))
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.finish()
                    dismiss()
                } label: {
                    Text("Done").font(.body.weight(.semibold))
                }
                .disabled(viewModel.name.isEmpty || viewModel.profileID.isEmpty)
            }
        }
    }
    
    private var nameRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer().frame(width: 8)
                Text("Name").font(.subheadline).foregroundColor(.secondaryLabel)
            }

            ModifiableTextField($viewModel.name)
                .placeholder("Enter name")
                .insets(EdgeInsets(16))
                .background(Color.secondarySystemGroupedBackground)
                .cornerRadius(8)
        }
        .listRowInsets(EdgeInsets(vertical: 8, horizontal: 0))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    private var shareIDRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer().frame(width: 8)
                Text("Profile ID").font(.subheadline).foregroundColor(.secondaryLabel)
            }

            ModifiableTextField($viewModel.profileID)
                .enabled(viewModel.contributor == nil)
                .placeholder("Enter Profile ID")
                .insets(EdgeInsets(16))
                .autocapitalizationType(.none)
                .background(Color.secondarySystemGroupedBackground)
                .cornerRadius(8)
                .fixedSize(horizontal: false, vertical: true)
                        
            Text("Ask contributor to share his/her Profile ID. To find Profile ID, tap the profile icon in the home screen.")
                .font(.subheadline)
                .foregroundColor(Color.secondaryLabel)
                .padding(.horizontal, 8)
        }
        .listRowInsets(EdgeInsets(vertical: 8, horizontal: 0))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

struct AddEditContributorView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = AddEditContributorViewModel(contributor: .johnDoe) { _ in }
        AddEditContributorView(viewModel: viewModel)
    }
}
