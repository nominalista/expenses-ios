//
//  HomeView.swift
//  Expenses
//
//  Created by Nominalista on 04/12/2021.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel
    
    @State var isWalletsViewPresented = false
    @State var isAddEditViewPresented = false
    @State var isProfileViewPresented = false
    @State var isFilterViewPresented = false
    @State var isMoreDialogPresented = false
    @State var isActivityViewPresented = false
    
    // Import
    @State var isFileImporterPresented = false
    @State var isImportErrorAlertPresented = false
    @State var importErrorAlertMessage: String?
    
    // Export
    @State var isShareSheetPresented = false
    @State var shareURL: URL?
    
    var body: some View {
        NavigationView {
            LinearGradient(
                gradient: Gradient(colors: viewModel.backgroundColors),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
                ZStack {
                    HomeListView(viewModel: viewModel)
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            AddButton(action: { isAddEditViewPresented.toggle() })
                        }
                    }
                }
            )
            .environment(\.colorScheme, .dark)
            
            
            .fileImporter(
                isPresented: $isFileImporterPresented,
                allowedContentTypes: [.commaSeparatedText],
                allowsMultipleSelection: false
            ) { result in
                viewModel.importTransactions(from: result)
            }
            .alert("Import failed", isPresented: $isImportErrorAlertPresented) {
                Button("OK", role: .cancel) {}
            } message: {
                LazyView { Text(importErrorAlertMessage!) }
            }
            .sheet(isPresented: $isShareSheetPresented) {
                
            } content: {
                ShareSheet(activityItems: [shareURL!]) {
                    viewModel.deleteExportedCSV(url: shareURL!)
                }
            }
            .sheet(isPresented: $isWalletsViewPresented) {
                
            } content: {
                let viewModel = WalletsViewModel(walletRepository: FirebaseWalletRepository.shared)
                WalletsView(viewModel: viewModel)
            }
            .sheet(isPresented: $isAddEditViewPresented) {
                
            } content: {
                LazyView {
                    let viewModel = AddEditTransactionViewModel(
                        transactionRepository: FirebaseTransactionRepository.shared,
                        transactionLimit: viewModel.transactionLimit,
                        transaction: nil
                    )
                    AddEditTransactionView(viewModel: viewModel)
                }
            }
            .sheet(isPresented: $isProfileViewPresented) {
                
            } content: {
                LazyView {
                    ProfileView(viewModel: .firebase)
                }
            }
            .sheet(isPresented: $isFilterViewPresented) {
                
            } content: {
                let viewModel = FilterViewModel(
                    walletRepository: FirebaseWalletRepository.shared,
                    tagRepository: FirebaseTagRepository.shared,
                    preselectedDateRange: self.viewModel.viewState.filterDateRange,
                    preselectedTags: self.viewModel.viewState.filterTags
                ) { (dateRange, tags) in
                    self.viewModel.applyFilters(dateRange: dateRange, tags: tags)
                }
                FilterView(viewModel: viewModel)
            }
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                leadingToolbarItemGroup
                principalToolbarItemGroup
                trailingToolbarItemGroup
            }
        }
        .progressDialog(isPresented: $viewModel.isImporting, message: "Importing…")
        .progressDialog(isPresented: $viewModel.isExporting, message: "Exporting…")
        .onReceive(viewModel.showActivityView) { url in
            shareURL = url
            isShareSheetPresented.toggle()
        }
        .onReceive(viewModel.showImportErrorAlert) { alertMessage in
            importErrorAlertMessage = alertMessage
            isImportErrorAlertPresented.toggle()
        }
    }
    
    private var leadingToolbarItemGroup: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            Button {
                isProfileViewPresented = true
            } label: {
                Image.icPerson24pt
            }
            .buttonStyle(.toolbarIcon)
        }
    }
    
    private var principalToolbarItemGroup: some ToolbarContent {
        ToolbarItemGroup(placement: .principal) {
            Button {
                
            } label: {
                HStack(spacing: 4) {
                    Spacer().frame(width: 8)
                    Text("My wallet")
                        .font(.system(.title3, design: .rounded).weight(.semibold))
                        .foregroundColor(.label)
                    Image(systemName: "chevron.down")
                        .font(.system(.body, design: .rounded).weight(.bold))
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.label)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private var trailingToolbarItemGroup: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button {
                isFilterViewPresented = true
            } label: {
                Image(uiImage: #imageLiteral(resourceName: "ic_filter_list_24pt"))
                    .renderingMode(.template)
            }
            .buttonStyle(.toolbarIcon)
            .padding(.trailing, 4)
            
            Button {
                isMoreDialogPresented = true
            } label: {
                Image(uiImage: #imageLiteral(resourceName: "ic_more_vert_24pt"))
                    .renderingMode(.template)
            }
            .buttonStyle(.toolbarIcon)
            .padding(.leading, 4)
            .confirmationDialog(
                "More",
                isPresented: $isMoreDialogPresented,
                titleVisibility: .visible
            ) {
                Button("Import (.csv)") {
                    isFileImporterPresented.toggle()
                }
                
                Button("Export (.csv)") {
                    viewModel.exportCSV()
                }

                Button("Delete all") {
                    viewModel.deleteAllTransactions()
                }
            }
        }
    }
    
    private func shareCSV(withURL url: URL) {
        share(items: [url], excludedActivityTypes: nil) {
            viewModel.deleteExportedCSV(url: url)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView(viewModel: .preview)
    }
}
