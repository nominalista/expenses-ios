//
//  FilterView.swift
//  Expenses
//
//  Created by Nominalista on 25/12/2021.
//

import Foundation
import SwiftUI

struct FilterView: View {
    
    @StateObject var viewModel: FilterViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Date range")) {
                    ForEach(viewModel.dateRanges, id: \.self) {
                        dateRangeRow(for: $0)
                    }
                }.headerProminence(.increased)
                
                Section(header: VStack {
                    Text("Tags")}
                ) {
                    ForEach(viewModel.tags, id: \.id) { tag in
                        let isSelected = viewModel.selectedTags.contains(tag)
                        TagRow(tag: tag, isSelected: isSelected) {
                            if isSelected {
                                viewModel.deselect(tag: tag)
                            } else {
                                viewModel.select(tag: tag)
                            }
                        }
                    }
                }.headerProminence(.increased)
            }
            .listStyle(.insetGrouped)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.system(.body).weight(.semibold))
                    })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.applyFilters()
                        dismiss()
                    } label: {
                        Text("Filter").font(.body.weight(.semibold))
                    }
                }
            }
        }
    }
    
    private func dateRangeRow(for dateRange: FilterDateRange) -> some View {
        let isSelected = viewModel.selectedDateRange == dateRange
        return Button {
            viewModel.select(dateRange: dateRange)
        } label: {
            HStack {
                Text(dateRange.name).foregroundColor(Color(UIColor.label))
                Spacer().frame(minWidth: 16)
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(.body).weight(.semibold))
                        .foregroundColor(Color(UIColor.systemBlue))
                }
            }
        }
    }
}

private struct TagRow: View {
    
    var tag: Tag
    var isSelected: Bool
    var didSelect: () -> Void
    
    var body: some View {
        Button {
            didSelect()
        } label: {
            HStack {
                Text(tag.name).foregroundColor(Color(UIColor.label))
                Spacer().frame(minWidth: 16)
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(.body).weight(.semibold))
                        .foregroundColor(Color(UIColor.systemBlue))
                }
            }
        }
    }
}

private extension FilterDateRange {
    var name: String {
        switch self {
        case .allTime:
            return "All time"
        case .today:
            return "Today"
        case .thisWeek:
            return "This week"
        case .thisMonth:
            return "This month"
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    
    static var previews: some View {
        FilterView(viewModel: FilterViewModel())
    }
}


