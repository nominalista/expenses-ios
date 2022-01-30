//
//  AddButton.swift
//  Expenses
//
//  Created by Nominalista on 04/12/2021.
//

import Foundation
import SwiftUI

struct AddButton: View {
    
    var action: (() -> Void)?
    
    var body: some View {
        Button {
            action?()
        } label: {
            Image(uiImage: #imageLiteral(resourceName: "ic_create_24pt"))
                .renderingMode(.template)
                .foregroundColor(.white)
                .padding(16)
        }
        .background(Color.brandSecondary)
        .clipShape(Capsule())
        .padding(16)
        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton()
    }
}
