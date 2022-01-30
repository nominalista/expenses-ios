//
//  String+base64.swift
//  Expenses
//
//  Created by Nominalista on 09/01/2022.
//

import Foundation

import Foundation

extension String {
    
    init?(base64Encoded: String) {
        guard let data = Data(base64Encoded: base64Encoded) else {
            return nil
        }
        self.init(data: data, encoding: .utf8)
    }
    
    var base64Encoded: String? {
        data(using: .utf8)?.base64EncodedString()
    }
}
