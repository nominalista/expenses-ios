//
//  TagsViewModel.swift
//  Expenses
//
//  Created by Nominalista on 13/12/2021.
//

import Combine
import Foundation

class TagsViewModel: ObservableObject {
    
    @Published var tags = [Tag]()
    @Published var selectedTags = Set<Tag>()
    
    var restrictedTagNames: Set<String> {
        Set(tags.map { $0.name })
    }
    
    private let walletRepository: WalletRepository
    private let tagRepository: TagRepository
    
    private var tagsObservationCancellable: AnyCancellable?
    
    init(
        walletRepository: WalletRepository,
        tagRepository: TagRepository
    ) {
        self.walletRepository = walletRepository
        self.tagRepository = tagRepository
        
        let walletID = walletRepository.selectedWalletID ?? ""
        tagsObservationCancellable = tagRepository
            .observeTags(forWalletWithID: walletID)
            .sink { _ in
                
            } receiveValue: { [weak self] tags in
                self?.tags = tags.sorted(by: { $0.name < $1.name })
            }
    }
    
    func select(tag: Tag) {
        selectedTags.insert(tag)
    }
    
    func deselect(tag: Tag) {
        selectedTags.remove(tag)
    }
    
    func saveTag(withName name: String) {
        let walletID = walletRepository.selectedWalletID ?? ""
        let tag = Tag(id: UUID().uuidString, name: name)
        _ = tagRepository.insert(tag: tag, toWalletWithID: walletID)
    }
    
    func deleteTags(at indexSet: IndexSet) {
        let walletID = walletRepository.selectedWalletID ?? ""
        let tagsToDelete = indexSet.map { tags[$0] }
        tagsToDelete.forEach { tag in
            tagRepository.deleteTag(withID: tag.id, forWalletWithID: walletID)
        }
    }
}
