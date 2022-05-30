//
//  ToolbarTextButtonStyle.swift
//  Expenses
//
//  Created by Nominalista on 05/02/2022.
//

import SwiftUI

struct ToolbarTextButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        ToolbarTextButton(configuration: configuration)
    }
    
    struct ToolbarTextButton: View {
        
        @Environment(\.isEnabled) var isEnabled: Bool
        
        let configuration: ButtonStyle.Configuration
        
        var body: some View {
            configuration
                .label
                .font(.body.weight(.semibold))
                .frame(height: 36)
                .padding(.horizontal, 8)
                .foregroundColor(.brandPrimary)
                .backgroundColor(.systemGray5)
                .clipShape(Capsule())
                .opacity(configuration.isPressed || !isEnabled ? 0.5 : 1)
        }
    }
}

extension ButtonStyle where Self == ToolbarTextButtonStyle {
    
    static var toolbarText: ToolbarTextButtonStyle {
        ToolbarTextButtonStyle()
    }
}

struct ToolbarTextButtonStyle_Previews: PreviewProvider {
    
    static var previews: some View {
        Button {
            // Do nothing.
        } label: {
            Text("Button")
        }
        .buttonStyle(.toolbarText)
        .previewLayout(.sizeThatFits)
    }
}

