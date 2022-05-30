//
//  TagRepository.swift
//  Expenses
//
//  Created by Nominalista on 06/02/2022.
//

import Combine

protocol TagRepository {
    
    func observeTags(forWalletWithID walletID: String) -> AnyPublisher<[Tag], Error>
    
    func getTags(forWalletWithID walletID: String) async -> Result<[Tag], Error>
    
    func insert(tag: Tag, toWalletWithID walletID: String) -> Tag
    
    func deleteTag(withID id: String, forWalletWithID walletID: String)
    
    func deleteAllTags(fromWalletWithID walletID: String) async -> Result<Void, Error>
}

