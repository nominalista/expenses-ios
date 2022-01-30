//
//  TextFieldModifier.swift
//  Expenses
//
//  Created by Nominalista on 04/12/2021.
//

import Foundation
import SwiftUI

struct TextFieldContentPaddingModifier: ViewModifier {
    
    let length: CGFloat
    
    func body(content: Content) -> some View {
        content.padding(length)
    }
}

extension TextField {
    
    func contentPadding(_ length: CGFloat) -> some View {
        self.modifier(TextFieldContentPaddingModifier(length: length))
    }
}
