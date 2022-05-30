//
//  Tag.swift
//  Expenses
//
//  Created by Nominalista on 12/12/2021.
//

import Foundation

struct Tag: Hashable, Codable, Identifiable {
    
    var id: String
    var name: String
    
    init(id: String = UUID().uuidString, name: String) {
        self.id = id
        self.name = name
    }
}
