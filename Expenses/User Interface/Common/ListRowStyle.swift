//
//  ListRowStyle.swift
//  Expenses
//
//  Created by Nominalista on 07/02/2022.
//

import SwiftUI

struct ListRowStyle<Background: View> {
    var insets: EdgeInsets
    var separatorVisbility: Visibility
    var background: Background
}

extension ListRowStyle where Background == Color {
    
    static var plain: ListRowStyle<Color> {
        ListRowStyle(insets: .zero, separatorVisbility: .hidden, background: .clear)
    }
}

struct ListRowStyleModifier<Background: View>: ViewModifier {
    
    var style: ListRowStyle<Background>
    
    func body(content: Content) -> some View {
        content
            .listRowInsets(style.insets)
            .listRowSeparator(style.separatorVisbility)
            .listRowBackground(style.background)
    }
}

extension View {
    
    func listRowStyle<Background: View>(_ style: ListRowStyle<Background>) -> some View {
        modifier(ListRowStyleModifier(style: style))
    }
}

