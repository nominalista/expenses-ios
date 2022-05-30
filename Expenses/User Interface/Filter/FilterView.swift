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
                    fixedDateRangeRow(for: .allTime)
                    fixedDateRangeRow(for: .today)
                    fixedDateRangeRow(for: .thisWeek)
                    fixedDateRangeRow(for: .thisMonth)
                    customDateRangeRow()
                }.headerProminence(.increased)
                
                Section(header: Text("Tags")) {
                    ForEach(viewModel.tags) { tag in
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
                    Button {
                        dismiss()
                    } label: {
                        Image.icClose24pt
                    }
                    .buttonStyle(.toolbarIcon)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.applyFilters()
                        dismiss()
                    } label: {
                        Text("Filter")
                    }
                    .buttonStyle(.toolbarText)
                }
            }
        }
    }
    
    private func fixedDateRangeRow(for dateRange: DateRange) -> some View {
        let isSelected = viewModel.selectedDateRange == dateRange
        return Button {
            viewModel.select(dateRange: dateRange)
        } label: {
            HStack(spacing: 0) {
                Text(dateRange.name).foregroundColor(Color(UIColor.label))
                Spacer().frame(minWidth: 16)
                if isSelected {
                    Image.icCheck24pt
                        .foregroundColor(.brandPrimary)
                }
            }
        }
    }
    
    private func customDateRangeRow() -> some View {
        let isSelected: Bool
        switch viewModel.selectedDateRange {
        case .custom:
            isSelected = true
        default:
            isSelected = false
        }
        
        return Button {
            let dateRange: DateRange = .custom(
                viewModel.customDateRangeStartDate,
                viewModel.customDateRangeEndDate
            )
            viewModel.select(dateRange: dateRange)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Custom").foregroundColor(Color(UIColor.label))
                    Spacer().frame(minWidth: 16)
                    if isSelected {
                        Image.icCheck24pt
                            .foregroundColor(.brandPrimary)
                    }
                }
                
                if isSelected {
                    HStack(spacing: 4) {
                        DatePicker(
                            "Start date",
                            selection: $viewModel.customDateRangeStartDate,
                            displayedComponents: .date
                        ).labelsHidden()
                        
                        Text("-")
                            .font(.body)
                            .foregroundColor(.label)
                        
                        DatePicker(
                            "End date",
                            selection: $viewModel.customDateRangeEndDate,
                            displayedComponents: .date
                        ).labelsHidden()
                    }
                }
            }
            .if(isSelected) {
                $0.padding(.vertical, 8)
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

private extension DateRange {
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
        case .custom:
            return "Custom"
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = FilterViewModel(
            walletRepository: FakeWalletRepostiory(),
            tagRepository: FakeTagRepository()
        )
        FilterView(viewModel: viewModel)
    }
}


