//
//  WalletButtonStyle.swift
//  Expenses
//
//  Created by Nominalista on 06/02/2022.
//

import SwiftUI

struct WalletButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.onBrandPrimary)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}
