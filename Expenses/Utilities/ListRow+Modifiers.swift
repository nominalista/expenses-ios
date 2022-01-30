//
//  ListRow+Modifiers.swift
//  Expenses
//
//  Created by Nominalista on 29/12/2021.
//

import SwiftUI

struct ClearListRowModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .listRowSeparator(.hidden)
            .listRowInsets(.zero)
            .listRowBackground(Color.clear)
    }
}

extension View {
    
    func clearListRow() -> some View {
        modifier(ClearListRowModifier())
    }
}
