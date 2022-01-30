//
//  EdgeInsets+Initializers.swift
//  Expenses
//
//  Created by Nominalista on 26/12/2021.
//

import SwiftUI

extension EdgeInsets {
    
    static var zero: EdgeInsets {
        EdgeInsets()
    }
    
    init(_ length: CGFloat = 0) {
        self.init(top: length, leading: length, bottom: length, trailing: length)
    }
    
    init(vertical: CGFloat = 0, horizontal: CGFloat = 0) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
}
