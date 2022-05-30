//
//  Tag+Examples.swift
//  Expenses
//
//  Created by Nominalista on 06/02/2022.
//

import Foundation

extension Tag {
    
    static var examples: [Tag] {
        [.bills, .food, .shopping]
    }
    
    static var bills: Tag {
        Tag(id: "bills", name: "Bills")
    }
    
    static var food: Tag {
        Tag(id: "food", name: "Food")
    }
    
    static var shopping: Tag {
        Tag(id: "shopping", name: "Shopping")
    }
}
