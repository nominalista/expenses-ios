//
//  ShareSheet.swift
//  Expenses
//
//  Created by Nominalista on 17/01/2022.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    var excludedActivityTypes: [UIActivity.ActivityType]? = nil
    
    var completion: () -> Void
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let viewController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        viewController.excludedActivityTypes = excludedActivityTypes
        viewController.completionWithItemsHandler = { _, _, _, _ in
            completion()
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
