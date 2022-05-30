//
//  String+isBlank.swift
//  Expenses
//
//  Created by Nominalista on 13/01/2022.
//

import Foundation

extension String {
    
    var isEmptyOrBlank: Bool {
        isEmpty || isBlank
    }

    var isBlank: Bool {
        allSatisfy { $0.isWhitespace }
    }
}
