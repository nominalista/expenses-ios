//
//  File.swift
//
//
//  Created by Franklyn Weber on 04/02/2021.
//
import SwiftUI

extension View {
    
    /// View extension in the style of .sheet - offers no real customisation. If more flexibility is required, use HalfASheet(...) directly, and apply the required modifiers
    /// - Parameters:
    ///   - isPresented: binding to a Bool which controls whether or not to show the partial sheet
    ///   - title: an optional title for the sheet
    ///   - content: the sheet's content
    public func halfASheet<T: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> T) -> some View {
        modifier(HalfASheetPresentationModifier(content: { HalfASheet(isPresented: isPresented, content: content) }))
    }
}


struct HalfASheetPresentationModifier<SheetContent>: ViewModifier where SheetContent: View {
    
    var content: () -> HalfASheet<SheetContent>
    
    init(@ViewBuilder content: @escaping () -> HalfASheet<SheetContent>) {
        self.content = content
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            self.content()
        }
    }
}
