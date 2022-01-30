//
//  TextField.swift
//  Expenses
//
//  Created by Nominalista on 04/12/2021.
//

import Foundation
import SwiftUI

class ModifiableTextFieldConfiguration {
    var isEnabled: Bool = true
    var placeholder: String = ""
    var font: UIFont = .systemFont(ofSize: 17)
    var insets: EdgeInsets = .init()
    var textAlignment: NSTextAlignment = .natural
    var keyboardType: UIKeyboardType = .default
    var autocapitalizationType: UITextAutocapitalizationType = .sentences
}

struct ModifiableTextField: UIViewRepresentable {
    
    @Binding var text: String
    
    private var configuration = ModifiableTextFieldConfiguration()
    
    init(_ text: Binding<String>) {
        self._text = text
    }
    
    func makeUIView(context: Context) -> ModifiableUITextField {
        let textField = ModifiableUITextField(frame: .zero)
        textField.isUserInteractionEnabled = configuration.isEnabled
        textField.placeholder = configuration.placeholder
        textField.font = configuration.font
        textField.insets = configuration.insets.uiEdgeInsets
        textField.textAlignment = configuration.textAlignment
        textField.keyboardType = configuration.keyboardType
        textField.autocapitalizationType = configuration.autocapitalizationType
        textField.delegate = context.coordinator
        
        // Crucial for UITextField to respect parent frame.
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return textField
    }
    
    func updateUIView(_ uiView: ModifiableUITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        let parent: ModifiableTextField
        
        init(_ parent: ModifiableTextField) {
            self.parent = parent
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}

extension ModifiableTextField {
    
    func enabled(_ isEnabled: Bool) -> ModifiableTextField {
        self.configuration.isEnabled = isEnabled
        return self
    }
    
    func placeholder(_ placeholder: String) -> ModifiableTextField {
        self.configuration.placeholder = placeholder
        return self
    }
    
    func font(_ font: UIFont) -> ModifiableTextField {
        self.configuration.font = font
        return self
    }
    
    func insets(_ insets: EdgeInsets) -> ModifiableTextField {
        self.configuration.insets = insets
        return self
    }
    
    func textAlignment(_ textAlignment: NSTextAlignment) -> ModifiableTextField {
        self.configuration.textAlignment = textAlignment
        return self
    }
    
    func keyboardType(_ type: UIKeyboardType) -> ModifiableTextField {
        self.configuration.keyboardType = type
        return self
    }
    
    func autocapitalizationType(_ type: UITextAutocapitalizationType) -> ModifiableTextField {
        self.configuration.autocapitalizationType = type
        return self
    }
}
