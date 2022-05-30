//
//  FilterViewModel.swift
//  Expenses
//
//  Created by Nominalista on 25/12/2021.
//

import Combine
import Foundation

class FilterViewModel: ObservableObject {
    
    @Published var selectedDateRange: DateRange
    
    @Published var tags = [Tag]()
    @Published var selectedTags: Set<Tag>
    
    @Published var customDateRangeStartDate: Date {
        didSet { if oldValue != customDateRangeStartDate { updateCustomDateRange() } }
    }
    @Published var customDateRangeEndDate: Date {
        didSet { if oldValue != customDateRangeEndDate { updateCustomDateRange() } }
    }
    
    private func updateCustomDateRange() {
        switch selectedDateRange {
        case .custom:
            let startOfCustomDateRangeEndDate = customDateRangeStartDate.startOfDay!
            let endOfCustomDateRangeEndDate = customDateRangeEndDate.endOfDay!
            selectedDateRange = .custom(startOfCustomDateRangeEndDate, endOfCustomDateRangeEndDate)
        default:
            return
        }
    }
    
    private var didApplyFilters: ((DateRange, Set<Tag>) -> Void)?
    
    private let walletRepository: WalletRepository
    private let tagRepository: TagRepository
    
    private var tagsObservationCancellable: AnyCancellable?
    
    init(
        walletRepository: WalletRepository,
        tagRepository: TagRepository,
        preselectedDateRange: DateRange = .allTime,
        preselectedTags: Set<Tag> = Set(),
        didApplyFilters: ((DateRange, Set<Tag>) -> Void)? = nil
    ) {
        self.walletRepository = walletRepository
        self.tagRepository = tagRepository
        
        switch preselectedDateRange {
        case .custom(let start, let end):
            customDateRangeStartDate = start
            customDateRangeEndDate = end
        default:
            customDateRangeStartDate = .now
            customDateRangeEndDate = .now
        }
        self.selectedDateRange = preselectedDateRange
        
        self.selectedTags = preselectedTags
        self.didApplyFilters = didApplyFilters
        
        let walletID = walletRepository.selectedWalletID ?? ""
        tagsObservationCancellable = tagRepository
            .observeTags(forWalletWithID: walletID)
            .sink { _ in
                
            } receiveValue: { [weak self] tags in
                self?.tags = tags.sorted(by: { $0.name < $1.name })
            }
    }
    
    func select(dateRange: DateRange) {
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
