//
//  String+isBlank.swift
//  Expenses
//
//  Created by Nominalista on 13/01/2022.
//

import Foundation

extension String {
    var isBlank: Bool {
        allSatisfy { $0.isWhitespace }
    }
}
