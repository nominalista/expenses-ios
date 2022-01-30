//
//  TagsView.swift
//  Expenses
//
//  Created by Nominalista on 13/12/2021.
//

import Foundation
import SwiftUI

struct TagsView: View {
    
    @StateObject var viewModel = TagsViewModel()
    
    @State var isAddTagAlertPresented = false
    
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
                
                Button {
                    isAddTagAlertPresented = true
                } label: {
                    HStack {
                        Image(systemName: "plus")
                            .font(.system(.body).weight(.semibold))
                        Text("Add tag")
                        Spacer()
                    }
                    .background(.clear)
                }
                .foregroundColor(Color.systemBlue)
                .addTagAlert(isPresented: $isAddTagAlertPresented) { tagName in
                    viewModel.saveTag(withName: tagName)
                }
                
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Select tags")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(.body).weight(.semibold))
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(
                    action: {
                        didSelectTags(Array(viewModel.selectedTags))
                        dismiss()
                    },
                    label: {
                        Text("Select").font(.body.weight(.semibold))
                    }
                )
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
        TagsView { _ in }
            .preferredColorScheme(.dark)
    }
}
