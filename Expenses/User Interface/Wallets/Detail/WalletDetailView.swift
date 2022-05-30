import SwiftUI

struct WalletDetailView: View {
    
    @StateObject var viewModel: WalletDetailViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isAddEditContributorLinkActive = false
    @State private var isDeleteAlertPresented = false
    
    var body: some View {
        Form {
            emojiAndNameRow
            ownerNameRow
        
            ContributorsRow().environmentObject(viewModel)
            
            if viewModel.isDeletable {
                deleteRow
            }
        }
        .alert("Delete wallet?", isPresented: $isDeleteAlertPresented) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) { viewModel.delete() }
        }
        .navigationTitle("Wallet")
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
                if viewModel.isEditable {
                    Button {
                        viewModel.save()
                    } label: {
                        Text("Save")
                    }
                    .buttonStyle(.toolbarText)
                }
            }
        }
        .onReceive(viewModel.dismissPublisher) { shouldDismiss in
            if shouldDismiss { dismiss() }
        }
    }
    
    private var emojiAndNameRow: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Spacer().frame(width: 8)
                    Text("Emoji")
                        .font(.subheadline)
                        .foregroundColor(.secondaryLabel)
                }
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.secondarySystemGroupedBackground)
                        .cornerRadius(8)
                        
                    Text(viewModel.emoji)
                        .font(.largeTitle)
                }
                .frame(width: 80, height: 54)
                .onTapGesture {
                    viewModel.shuffleEmoji()
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Spacer().frame(width: 8)
                    Text("Name")
                        .font(.subheadline)
                        .foregroundColor(.secondaryLabel)
                }

                ModifiableTextField($viewModel.name)
                    .enabled(viewModel.isEditable)
                    .placeholder("Enter name")
                    .insets(EdgeInsets(16))
                    .background(Color.secondarySystemGroupedBackground)
                    .cornerRadius(8)
            }
        }
        .listRowInsets(EdgeInsets(vertical: 8, horizontal: 0))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    private var ownerNameRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer().frame(width: 8)
                Text("Owner")
                    .font(.subheadline)
                    .foregroundColor(.secondaryLabel)
            }

            ModifiableTextField($viewModel.ownerName)
                .enabled(viewModel.isEditable)
                .placeholder("Enter owner")
                .insets(EdgeInsets(16))
                .background(Color.secondarySystemGroupedBackground)
                .cornerRadius(8)
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
                Image(systemName: "trash")
                    .font(.system(.headline).weight(.semibold))
                    .foregroundColor(Color.systemRed)
                Spacer().frame(width: 8)
                Text("Delete")
                    .font(.headline)
                    .foregroundColor(Color.systemRed)
                Spacer()
            }
        }
        .padding()
        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(8)
        .listRowInsets(EdgeInsets(vertical: 24, horizontal: 0))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

struct WalletDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = WalletDetailViewModel(
            walletRepository: FakeWalletRepostiory(),
            transactionRepository: FakeTransactionRepository(),
            tagRepository: FakeTagRepository(),
            wallet: .home
        )
        WalletDetailView(viewModel: viewModel)
    }
}
