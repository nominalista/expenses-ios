//
//  ModifiableTextField.swift
//  Expenses
//
//  Created by Nominalista on 04/12/2021.
//

import UIKit

class ModifiableUITextField: UITextField {
  
    var insets: UIEdgeInsets = .zero
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: insets)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: insets)
    }
}
