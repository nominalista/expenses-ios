//
//  AddEditContributorViewModel.swift
//  Expenses
//
//  Created by Nominalista on 08/01/2022.
//

import Combine
import Foundation

class AddEditContributorViewModel: ObservableObject {
    
    @Published var name = ""
    @Published var profileID = ""
    
    private(set) var contributor: Wallet.User?
    
    var isDeletable: Bool {
        contributor != nil
    }
    
    private let didAddEdit: (Wallet.User) -> Void
    private let didDelete: (Wallet.User) -> Void
    
    init(
        contributor: Wallet.User?,
        didAddEdit: @escaping (Wallet.User) -> Void,
        didDelete: @escaping (Wallet.User) -> Void
    ) {
        self.contributor = contributor
        self.name = contributor?.name ?? ""
        self.profileID = contributor?.id.base64Encoded ?? ""
        self.didAddEdit = didAddEdit
        self.didDelete = didDelete
    }
    
    func finish() {
        let id = String(base64Encoded: profileID) ?? ""
        let contributor = Wallet.User(id: id, name: name)
        didAddEdit(contributor)
    }
    
    func delete() {
        didDelete(contributor!)
    }
}
