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
    @State var isProfileDialogPresented = false
    @State var isFilterViewPresented = false
    @State var isMoreDialogPresented = false
    @State var isActivityViewPresented = false
    
    // Import
    @State var isFileImporterPresented = false
    @State var isImportErrorAlertPresented = false
    @State var importErrorAlertMessage: String?
    
    // Expor
    @State var isShareSheetPresented = false
    @State var shareURL: URL?
    
    var body: some View {
        NavigationView {
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
                        transaction: nil
                    )
                    AddEditTransactionView(viewModel: viewModel)
                }
            }
            .sheet(isPresented: $isFilterViewPresented) {
                
            } content: {
                let viewModel = FilterViewModel(
                    preselectedDateRange: self.viewModel.filterDateRange,
                    preselectedTags: self.viewModel.filterTags
                ) { (dateRange, tags) in
                    self.viewModel.applyFilters(dateRange: dateRange, tags: tags)
                }
                FilterView(viewModel: viewModel)
            }
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                leadingToolbarItemGroup
                // principalToolbarItemGroup
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
                isProfileDialogPresented = true
            } label: {
                Image(uiImage: #imageLiteral(resourceName: "ic_person_24pt"))
                    .renderingMode(.template)
                    .foregroundColor(.brandPrimary)
                    .padding(6)
                    .background(Color.systemGray5)
                    .clipShape(Circle())
            }
            .confirmationDialog(
                viewModel.userDisplayName ?? "",
                isPresented: $isProfileDialogPresented,
                titleVisibility: .visible
            ) {
                Button("Log out") {
                    viewModel.logOut()
                }
            } message: {
                Text(viewModel.userEmail ?? "")
            }
        }
    }
    
    private var trailingToolbarItemGroup: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button {
                isFilterViewPresented = true
            } label: {
                Image(uiImage: #imageLiteral(resourceName: "ic_filter_list_24pt"))
                    .renderingMode(.template)
                    .foregroundColor(.brandPrimary)
                    .padding(6)
                    .background(Color.systemGray5)
                    .clipShape(Circle())
            }
            
            Button {
                isMoreDialogPresented = true
            } label: {
                Image(uiImage: #imageLiteral(resourceName: "ic_more_vert_24pt"))
                    .renderingMode(.template)
                    .foregroundColor(.brandPrimary)
                    .padding(6)
                    .background(Color.systemGray5)
                    .clipShape(Circle())
            }
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
        let viewModel = HomeViewModel(
            walletRepository: FakeWalletRepostiory(),
            transactionRepostiory: FakeTransactionRepository()
        )
        HomeView(viewModel: viewModel)
    }
}
