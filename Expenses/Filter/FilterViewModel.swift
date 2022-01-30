//
//  FilterViewModel.swift
//  Expenses
//
//  Created by Nominalista on 25/12/2021.
//

import Foundation
import FirebaseFirestore

class FilterViewModel: ObservableObject {
    
    let dateRanges = [
        FilterDateRange.allTime,
        FilterDateRange.today,
        FilterDateRange.thisWeek,
        FilterDateRange.thisMonth
    ]
    
    @Published var selectedDateRange: FilterDateRange
    
    @Published var tags = [Tag]()
    @Published var selectedTags: Set<Tag>
    
    private var didApplyFilters: ((FilterDateRange, Set<Tag>) -> Void)?
    
    private var tagsListenerRegistration: ListenerRegistration?
    
    init(
        preselectedDateRange: FilterDateRange = .allTime,
        preselectedTags: Set<Tag> = Set(),
        didApplyFilters: ((FilterDateRange, Set<Tag>) -> Void)? = nil
    ) {
        self.selectedDateRange = preselectedDateRange
        self.selectedTags = preselectedTags
        self.didApplyFilters = didApplyFilters
        
        let walletID = UserDefaults.standard.selectedWalletID ?? ""
        tagsListenerRegistration = TagDataStore.shared
            .observeTags(forWalletWithID: walletID) { [weak self] result in
                switch result {
                case .success(let tags):
                    self?.tags = tags.sorted(by: { $0.name < $1.name })
                case .failure(let error):
                    print("Failed to observe tags (\(error.localizedDescription)).")
                    self?.tags = []
                }
            }
    }
    
    deinit {
        tagsListenerRegistration?.remove()
        tagsListenerRegistration = nil
    }
    
    func select(dateRange: FilterDateRange) {
        selectedDateRange = dateRange
    }
    
    func select(tag: Tag) {
        selectedTags.insert(tag)
    }
    
    func deselect(tag: Tag) {
        selectedTags.remove(tag)
    }
    
    func applyFilters() {
        didApplyFilters?(selectedDateRange, selectedTags)
    }
}
