//
//  MediumSheet.swift
//  Expenses
//
//  Created by Nominalista on 07/01/2022.
//

import SwiftUI

struct MediumSheet<Content: View>: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    @Binding var isExpanded: Bool
    
    let content: Content
    
    init(
        isPresented: Binding<Bool>,
        isExpanded: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isPresented = isPresented
        self._isExpanded = isExpanded
        self.content = content()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(sheet: self)
    }
    
    func makeUIViewController(context: Context) -> MediumSheetViewController<Content> {
        MediumSheetViewController(coordinator: context.coordinator, content: { content })
    }
    
    func updateUIViewController(
        _ uiViewController: MediumSheetViewController<Content>,
        context: Context
    ) {
        if isPresented {
            uiViewController.present()
        } else {
            uiViewController.dismiss(animated: true, completion: nil)
        }
        
        if isExpanded {
            uiViewController.expand()
        } else {
            uiViewController.compress()
        }
    }
    
    class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        
        var sheet: MediumSheet
        
        init(sheet: MediumSheet) {
            self.sheet = sheet
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            if sheet.isPresented {
                sheet.isPresented = false
            }
        }
    }
}

class MediumSheetViewController<Content: View>: UIViewController {
    
    let coordinator: MediumSheet<Content>.Coordinator
    let content: Content
    
    init(
        coordinator: MediumSheet<Content>.Coordinator,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.coordinator = coordinator
        self.content = content()
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func present() {
        let hostingController = UIHostingController(rootView: content)
        hostingController.modalPresentationStyle = .popover
        hostingController.presentationController?.delegate = coordinator
        hostingController.modalTransitionStyle = .coverVertical
        
        if let popoverPresentationController = hostingController.popoverPresentationController {
            popoverPresentationController.sourceView = super.view
            
            let sheet = popoverPresentationController.adaptiveSheetPresentationController
            // For compact height, only .large() is an active detent.
            sheet.detents = [.medium(), .large()]
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        
        if presentedViewController == nil {
            present(hostingController, animated: true, completion: nil)
        }
    }
    
    private var sheet: UISheetPresentationController? {
        presentedViewController?.popoverPresentationController?.adaptiveSheetPresentationController
    }
    
    func expand() {
        if let sheet = sheet, sheet.selectedDetentIdentifier != .large {
            sheet.animateChanges {
                sheet.selectedDetentIdentifier = .large
            }
        }
    }
    
    func compress() {
        if let sheet = sheet, sheet.selectedDetentIdentifier != .medium {
            sheet.animateChanges {
                sheet.selectedDetentIdentifier = .medium
            }
        }
    }
}

struct MediumSheetModifier<MediumSheetContent: View>: ViewModifier {
    
    @Binding var isPresented: Bool
    @Binding var isExpanded: Bool
    let mediumSheetContent: MediumSheetContent
    
    init(
        isPresented: Binding<Bool>,
        isExpanded: Binding<Bool>,
        @ViewBuilder content: @escaping () -> MediumSheetContent
    ) {
        self._isPresented = isPresented
        self._isExpanded = isExpanded
        self.mediumSheetContent = content()
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            MediumSheet(isPresented: $isPresented, isExpanded: $isExpanded) { mediumSheetContent }
            .frame(width: 0, height: 0)
        }
    }
}

extension View {
    
    func mediumSheet<Content: View>(
        isPresented: Binding<Bool>,
        isExpanded: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(
            MediumSheetModifier(isPresented: isPresented, isExpanded: isExpanded, content: content)
        )
    }
}
