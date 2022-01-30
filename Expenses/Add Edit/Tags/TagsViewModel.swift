//
//  TagsViewModel.swift
//  Expenses
//
//  Created by Nominalista on 13/12/2021.
//

import Foundation
import FirebaseFirestore

class TagsViewModel: ObservableObject {
    
    @Published var tags = [Tag]()
    @Published var selectedTags = Set<Tag>()
    
    private var tagsListenerRegistration: ListenerRegistration?
    
    init() {
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
    
    func select(tag: Tag) {
        selectedTags.insert(tag)
    }
    
    func deselect(tag: Tag) {
        selectedTags.remove(tag)
    }
    
    func saveTag(withName name: String) {
        let walletID = UserDefaults.standard.selectedWalletID ?? ""
        let tag = Tag(id: UUID().uuidString, name: name)
        TagDataStore.shared.insert(tag: tag, forWalletWithID: walletID) { result in
            switch result {
            case .success:
                print("Succeeded to insert tag.")
            case .failure(let error):
                print("Failed to insert tag (\(error.localizedDescription).")
            }
        }
    }
    
    func deleteTags(at indexSet: IndexSet) {
        let walletID = UserDefaults.standard.selectedWalletID ?? ""
        let tagsToDelete = indexSet.map { tags[$0] }
        tagsToDelete.forEach { tag in
            TagDataStore.shared.deleteTag(withID: tag.id, forWalletWithID: walletID)
        }
    }
}
