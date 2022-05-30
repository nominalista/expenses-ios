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
    
    init(_ edges: Edge.Set, _ length: CGFloat) {
        var top: CGFloat = 0
        var leading: CGFloat = 0
        var bottom: CGFloat = 0
        var trailing: CGFloat = 0
        
        switch edges {
        case .vertical:
            top = length
            bottom = length
            break
        case .horizontal:
            leading = length
            trailing = length
            break
        case .top:
            top = length
            break
        case .leading:
            leading = length
            break
        case .bottom:
            bottom = length
            break
        case .trailing:
            trailing = length
            break
        case .all:
            top = length
            leading = length
            bottom = length
            trailing = length
            break
        default:
            break
        }
        
        self.init(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
    
    init(vertical: CGFloat = 0, horizontal: CGFloat = 0) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
}
