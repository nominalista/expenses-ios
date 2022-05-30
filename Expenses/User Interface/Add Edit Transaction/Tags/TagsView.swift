//
//  TagsView.swift
//  Expenses
//
//  Created by Nominalista on 13/12/2021.
//

import Foundation
import SwiftUI

struct TagsView: View {
    
    @StateObject var viewModel: TagsViewModel
    
    @State var isAddTagLinkActive = false
    
    @Environment(\.dismiss) var dismiss
    
    var didSelectTags: (([Tag]) -> Void)
        
    var body: some View {
        List {
            Section {
                ForEach(viewModel.tags, id: \.id) { tag in
                    tagRow(tag: tag)
                }
                .onDelete { indexSet in
                    viewModel.deleteTags(at: indexSet)
                }
                
                ZStack {
                    NavigationLink(isActive: $isAddTagLinkActive) {
                        LazyView {
                            let viewModel = AddTagViewModel.firebase(
                                restrictedTagNames: viewModel.restrictedTagNames
                            )
                            AddTagView(viewModel: viewModel)
                        }
                    } label: {
                        EmptyView()
                    }
                    .frame(width: 0, height: 0)
                    .hidden()
                    
                    HStack {
                        Image(systemName: "plus")
                            .font(.body.weight(.semibold))
                        Text("Add tag")
                            .font(.headline)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .background(.clear)
                    .foregroundColor(.brandPrimary)
                }
                .onTapGesture {
                    isAddTagLinkActive.toggle()
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Select tags")
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
                    didSelectTags(Array(viewModel.selectedTags))
                    dismiss()
                } label: {
                    Text("Select")
                }
                .buttonStyle(.toolbarText)
            }
        }
    }
    
    private func tagRow(tag: Tag) -> some View {
        let isSelected = viewModel.selectedTags.contains(tag)
        return Button {
            if isSelected {
                viewModel.deselect(tag: tag)
            } else {
                viewModel.select(tag: tag)
            }
        } label: {
            HStack {
                Text(tag.name).foregroundColor(Color(UIColor.label))
                Spacer()
                
                if isSelected {
                    Spacer().frame(width: 16)
                    Image(systemName: "checkmark")
                        .font(.system(.body).weight(.semibold))
                        .foregroundColor(Color(UIColor.systemBlue))
                }
            }
        }
    }
}

struct TagsView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = TagsViewModel(
            walletRepository: FakeWalletRepostiory(),
            tagRepository: FakeTagRepository()
        )
        TagsView(viewModel: viewModel) { _ in }
            .preferredColorScheme(.dark)
    }
}
