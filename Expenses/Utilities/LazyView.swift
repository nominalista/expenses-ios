//
//  LazyView.swift
//  Expenses
//
//  Created by Nominalista on 17/01/2022.
//

import SwiftUI

struct LazyView<Content: View>: View {
    
    @ViewBuilder var content: () -> Content
    
    var body: Content {
        content()
    }
}
