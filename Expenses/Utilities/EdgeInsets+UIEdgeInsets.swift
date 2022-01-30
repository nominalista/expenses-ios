//
//  EdgeInsets+UIEdgeInsets.swift
//  Expenses
//
//  Created by Nominalista on 26/12/2021.
//

import SwiftUI

extension EdgeInsets {
    
    var uiEdgeInsets: UIEdgeInsets {
        UIEdgeInsets(top: top, left: leading, bottom: bottom, right: trailing)
    }
}
