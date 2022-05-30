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
    
    @State private var isDeleteAlertPresented = false
    
    var body: some View {
        Form {
            nameRow
            profileIDRow
            if viewModel.isDeletable {
                deleteRow
            }
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
                    Image.icArrowBack24pt
                }
                .buttonStyle(.toolbarIcon)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.finish()
                    dismiss()
                } label: {
                    Text("Done")
                }
                .buttonStyle(.toolbarText)
                .disabled(viewModel.name.isEmpty || viewModel.profileID.isEmpty)
            }
        }
        .alert("Delete contributor?", isPresented: $isDeleteAlertPresented) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                viewModel.delete()
                dismiss()
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
    
    private var profileIDRow: some View {
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
    
    private var deleteRow: some View {
        Button {
            isDeleteAlertPresented.toggle()
        } label: {
            HStack {
                Spacer()
                Image.icDelete24pt
                    .foregroundColor(.systemRed)
                Spacer().frame(width: 8)
                Text("Delete")
                    .font(.headline)
                    .foregroundColor(.systemRed)
                Spacer()
            }
        }
        .padding(16)
        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(8)
        .listRowInsets(EdgeInsets(top: 32, leading: 0, bottom: 0, trailing: 0))
        .listRowStyle(.plain)
    }
}

struct AddEditContributorView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            let viewModel = AddEditContributorViewModel(
                contributor: .johnDoe,
                didAddEdit: { _ in },
                didDelete: { _ in }
            )
            AddEditContributorView(viewModel: viewModel)
        }
    }
}
