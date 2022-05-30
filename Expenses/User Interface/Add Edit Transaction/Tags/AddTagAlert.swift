//
//  AddTagAlert.swift
//  Expenses
//
//  Created by Nominalista on 14/12/2021.
//

import Foundation
import SwiftUI
import UIKit

struct AddTagAlert<Content: View>: UIViewControllerRepresentable {
    
    class Coordinator {
        
        var alertController: UIAlertController?
        
        init(_ controller: UIAlertController? = nil) {
            self.alertController = controller
        }
    }
    
    @Binding var isPresented: Bool
    
    var didTapAdd: (String) -> Void
    
    let content: Content
    
    func makeUIViewController(context: Context) -> UIHostingController<Content> {
        UIHostingController(rootView: content)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func updateUIViewController(
        _ uiViewController: UIHostingController<Content>,
        context: Context
    ) {
        uiViewController.rootView = content
        uiViewController.view?.backgroundColor = .clear
        
        if isPresented && uiViewController.presentedViewController == nil {
            let alertController = makeAlertController()
            context.coordinator.alertController = alertController
            uiViewController.present(alertController, animated: true)
            return
        }
        
        if let presentedViewController = uiViewController.presentedViewController,
           let alertController = context.coordinator.alertController,
           !isPresented && presentedViewController == alertController {
            uiViewController.dismiss(animated: true)
        }
    }
    
    private func makeAlertController() -> UIAlertController {
        let alert = UIAlertController(
            title: "New tag",
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Name"
        }
        
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel) { _ in
                isPresented = false
            }
        )
        
        let textField = alert.textFields?.first
        alert.addAction(
            UIAlertAction(title: "Add", style: .default) { _ in
                isPresented = false
                didTapAdd(textField?.text ?? "")
            }
        )
        
        return alert
    }
}

extension View {
    
    func addTagAlert(
        isPresented: Binding<Bool>,
        didTapAdd: @escaping (String) -> Void
    ) -> some View {
        AddTagAlert(
            isPresented: isPresented,
            didTapAdd: didTapAdd,
            content: self
        )
    }
}
