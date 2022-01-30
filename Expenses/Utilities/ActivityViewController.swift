//
//  ActivityViewController.swift
//  Expenses
//
//  Created by Nominalista on 25/12/2021.
//

import UIKit

@discardableResult
func share(
    items: [Any],
    excludedActivityTypes: [UIActivity.ActivityType]? = nil,
    completion: (() -> Void)? = nil
) -> Bool {
    guard let source = UIApplication.shared.rootViewController else {
        return false
    }
    let viewController = UIActivityViewController(
        activityItems: items,
        applicationActivities: nil
    )
    viewController.excludedActivityTypes = excludedActivityTypes
    viewController.popoverPresentationController?.sourceView = source.view
    viewController.completionWithItemsHandler = { _, _, _, _ in
        print("UIActivityViewController completion handler.")
        completion?()
    }
    source.present(viewController, animated: true)
    return true
}

