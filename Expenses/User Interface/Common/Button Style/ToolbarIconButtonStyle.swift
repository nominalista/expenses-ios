//
//  ToolbarIconButtonStyle.swift
//  Expenses
//
//  Created by Nominalista on 05/02/2022.
//

import SwiftUI

struct ToolbarIconButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        ToolbarIconButton(configuration: configuration)
    }
    
    struct ToolbarIconButton: View {
        
        @Environment(\.isEnabled) var isEnabled: Bool
                
        let configuration: ButtonStyle.Configuration
        
        var body: some View {
            configuration
                .label
                .frame(width: 32, height: 32)
                .foregroundColor(.brandPrimary)
                .backgroundColor(.systemGray5)
                .clipShape(Circle())
                .opacity(configuration.isPressed || !isEnabled ? 0.5 : 1)
        }
    }
}

extension ButtonStyle where Self == ToolbarIconButtonStyle {
    
    static var toolbarIcon: ToolbarIconButtonStyle {
        ToolbarIconButtonStyle()
    }
}

struct ToolbarIconButtonStyle_Previews: PreviewProvider {
    
    static var previews: some View {
        Button {
            // Do nothing.
        } label: {
            Image(uiImage: #imageLiteral(resourceName: "ic_close_24pt"))
                .renderingMode(.template)
        }
        .buttonStyle(.toolbarIcon)
        .previewLayout(.sizeThatFits)
    }
}
