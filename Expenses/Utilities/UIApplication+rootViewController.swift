//
//  UIApplication+rootViewController.swift
//  Expenses
//
//  Created by Nominalista on 25/12/2021.
//

import UIKit

extension UIApplication {
    
    var rootWindow: UIWindow? {
        let activeWindowScene = connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first { $0 is UIWindowScene }
            .flatMap { $0 as? UIWindowScene }
        
        return activeWindowScene?.windows.first(where: \.isKeyWindow)
    }
    
    var rootViewController: UIViewController? {
        rootWindow?.rootViewController
    }
}
