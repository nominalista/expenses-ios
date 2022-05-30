import SwiftUI

struct AddTagView: View {
    
    @StateObject var viewModel: AddTagViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            nameRow
        }
        .navigationTitle("Add tag")
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
                    viewModel.saveTag()
                } label: {
                    Text("Save")
                }
                .buttonStyle(.toolbarText)
                .disabled(!viewModel.isSaveEnabled)
            }
        }
        .onReceive(viewModel.dismissPublisher) { _ in
            dismiss()
        }
    }
    
    private var nameRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer().frame(width: 8)
                Text("Name")
                    .font(.subheadline)
                    .foregroundColor(.secondaryLabel)
            }

            ModifiableTextField($viewModel.name)
                .placeholder("Bills, Entertainment, Shopping, etc.")
                .insets(EdgeInsets(16))
                .background(Color.secondarySystemGroupedBackground)
                .cornerRadius(8)
            
            if !viewModel.isSaveEnabled && !viewModel.name.isEmptyOrBlank {
                HStack {
                    Spacer().frame(width: 8)
                    Text("This tag already exists.")
                        .foregroundColor(.systemRed)
                        .font(.subheadline)
                }
            }
        }
        .listRowInsets(.zero)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

struct AddTagView_Previews: PreviewProvider {
    
    static var previews: some View {
        AddTagView(viewModel: .fake(restrictedTagNames: []))
    }
}

