//
//  IfModifier.swift
//  Expenses
//
//  Created by Nominalista on 04/01/2022.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, _ transform: (Self) -> Content)  -> some View {
        if condition { transform(self) } else { self }
    }
}
