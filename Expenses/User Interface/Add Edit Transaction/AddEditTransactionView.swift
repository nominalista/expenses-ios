//
//  AddEditTransactionView.swift
//  Expenses
//
//  Created by Nominalista on 04/12/2021.
//

import SwiftUI

struct AddEditTransactionView: View {
    
    private enum Field: Int, Hashable {
        case amount
    }
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: AddEditTransactionViewModel
    
    @FocusState private var focusedField: Field?
    
    @State var isCurrenciesLinkActive = false
    @State var isTagsLinkActive = false
        
    var body: some View {
        NavigationView {
            Form {
                amountCurrencyRow
                titleRow
                tagsRow
                dateRow
                notesRow
            }
            .background(Color.systemGroupedBackground)
            .listStyle(.plain)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(uiImage: #imageLiteral(resourceName: "ic_close_24pt"))
                            .renderingMode(.template)
                    }
                    .buttonStyle(.toolbarIcon)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.createOrUpdateTransaction()
                    } label: {
                        Text("Save")
                    }
                    .buttonStyle(.toolbarText)
                }
            }
            .onAppear { focusedField = .amount }
            .onReceive(viewModel.dismissPublisher) { _ in dismiss() }
        }
    }
    
    private var amountCurrencyRow: some View {
        GeometryReader { metrics in
            HStack(spacing: 16) {
                HStack(alignment: .center, spacing: 8) {
                    let isPlusSelected = viewModel.type == .income
                    let plusForegroundColor: Color = isPlusSelected ? .onBrandPrimary : .label
                    let plusBackgroundColor: Color = isPlusSelected ? .brandPrimary : .secondarySystemGroupedBackground
                    Image(systemName: "plus")
                        .font(.body.weight(.semibold))
                        .foregroundColor(plusForegroundColor)
                        .frame(width: 36, height: 36)
                        .background(plusBackgroundColor)
                        .clipShape(Circle())
                        .onTapGesture { viewModel.type = .income }
                    
                    let isMinusSelected = viewModel.type == .expense
                    let minusForegroundColor: Color = isMinusSelected ? .onBrandSecondary : .label
                    let minusBackgroundColor: Color = isMinusSelected ? .brandSecondary : .secondarySystemGroupedBackground
                    Image(systemName: "minus")
                        .font(.body.weight(.semibold))
                        .foregroundColor(minusForegroundColor)
                        .frame(width: 36, height: 36)
                        .background(minusBackgroundColor)
                        .clipShape(Circle())
                        .onTapGesture { viewModel.type = .expense }
                }
                .frame(width: 80)
                
                VStack(alignment: .leading, spacing: 8) {
                    ModifiableTextField($viewModel.amount)
                        .placeholder("0")
                        .font(.systemFont(ofSize: 24, weight: .semibold))
                        .insets(EdgeInsets(vertical: 0, horizontal: 0))
                        .textAlignment(.center)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .amount)
                        .backgroundColor(.secondarySystemGroupedBackground)
                        .cornerRadius(8)
                        .frame(width: max(0, metrics.size.width - 32 - 80 - 100), height: 56)
                }
                .frame(width: max(0, metrics.size.width - 32 - 80 - 100))
                
                VStack(alignment: .leading, spacing: 8) {
                    ZStack {
                        NavigationLink(isActive: $isCurrenciesLinkActive) {
                            CurrenciesView(viewModel: CurrenciesViewModel()) {
                                viewModel.select(currency: $0)
                            }
                        } label: {
                            EmptyView()
                        }
                        .frame(width: 0, height: 0)
                        .hidden()
                        
                        HStack {
                            Spacer()
                            Text(viewModel.currency)
                            Spacer()
                        }
                    }
                    .frame(height: 56)
                    .background(Color.secondarySystemGroupedBackground)
                    .cornerRadius(8)
                    .onTapGesture { isCurrenciesLinkActive = true }
                }
                .frame(width: 100)
            }
        }
        .frame(height: 56)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    private var titleRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer().frame(width: 8)
                Text("Title")
                    .font(.subheadline)
                    .foregroundColor(.secondaryLabel)
            }
            
            ModifiableTextField($viewModel.title)
                .placeholder("Enter title")
                .insets(EdgeInsets(16))
                .background(Color.secondarySystemGroupedBackground)
                .cornerRadius(8)
        }
        .listRowInsets(EdgeInsets(vertical: 8, horizontal: 0))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    private var tagsRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer().frame(width: 8)
                Text("Tags")
                    .font(.subheadline)
                    .foregroundColor(.secondaryLabel)
            }

            ZStack {
                NavigationLink(isActive: $isTagsLinkActive) {
                    LazyView {
                        let viewModel = TagsViewModel(
                            walletRepository: FirebaseWalletRepository.shared,
                            tagRepository: FirebaseTagRepository.shared
                        )
                        TagsView(viewModel: viewModel) { self.viewModel.select(tags: $0) }
                    }
                } label: {
                    EmptyView()
                }
                .frame(width: 0, height: 0)
                .hidden()
                
                ModifiableTextField($viewModel.tags)
                    .enabled(false)
                    .placeholder("Select tags")
                    .insets(EdgeInsets(16))
            }
            .background(Color.secondarySystemGroupedBackground)
            .cornerRadius(8)
            .onTapGesture { isTagsLinkActive = true }
        }
        .listRowInsets(EdgeInsets(vertical: 8, horizontal: 0))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    private var dateRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer().frame(width: 8)
                Text("Date")
                    .font(.subheadline)
                    .foregroundColor(.secondaryLabel)
            }
            
            HStack {
                DatePicker("Select date", selection: $viewModel.date).labelsHidden()
                Spacer()
            }
            .padding(16)
            .background(Color.secondarySystemGroupedBackground)
            .cornerRadius(8)
        }
        .listRowInsets(EdgeInsets(vertical: 8, horizontal: 0))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    private var notesRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer().frame(width: 8)
                Text("Notes")
                    .font(.subheadline)
                    .foregroundColor(.secondaryLabel)
            }
            
            TextEditor(text: $viewModel.notes)
                .padding(16)
                .background(Color.secondarySystemGroupedBackground)
                .cornerRadius(8)
                .frame(height: 100)
        }
        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

struct AddEditView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AddEditTransactionViewModel(
            transactionRepository: FakeTransactionRepository(),
            transaction: nil
        )
        Group {
            AddEditTransactionView(viewModel: viewModel)
                .preferredColorScheme(.light)
            
            AddEditTransactionView(viewModel: viewModel)
                .preferredColorScheme(.dark)
        }
    }
}
