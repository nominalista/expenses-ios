//
//  FakeTagRepository.swift
//  Expenses
//
//  Created by Nominalista on 06/02/2022.
//

import Combine
import Foundation

class FakeTagRepository: TagRepository {
    
    func observeTags(forWalletWithID walletID: String) -> AnyPublisher<[Tag], Error> {
        Just(Tag.examples)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getTags(forWalletWithID walletID: String) async -> Result<[Tag], Error> {
        fatalError("Not implemented.")
    }
    
    func insert(tag: Tag, toWalletWithID walletID: String) -> Tag {
        fatalError("Not implemented.")
    }
    
    func deleteTag(withID id: String, forWalletWithID walletID: String) {
        fatalError("Not implemented.")
    }
    
    func deleteAllTags(fromWalletWithID walletID: String) async -> Result<Void, Error> {
        fatalError("Not implemented.")
    }
}
