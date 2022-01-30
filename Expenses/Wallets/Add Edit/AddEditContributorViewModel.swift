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
    
    private let completion: (Wallet.User) -> Void
    
    init(contributor: Wallet.User?, completion: @escaping (Wallet.User) -> Void) {
        self.name = contributor?.name ?? ""
        self.profileID = contributor?.id.base64Encoded ?? ""
        self.contributor = contributor
        self.completion = completion
    }
    
    func finish() {
        let id = String(base64Encoded: profileID) ?? ""
        let contributor = Wallet.User(id: id, name: name)
        completion(contributor)
    }
}
