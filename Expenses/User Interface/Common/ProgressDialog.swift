//
//  ProcessingView.swift
//  Expenses
//
//  Created by Nominalista on 04/01/2022.
//

import SwiftUI

struct ProgressDialog<Container: View>: View {
    
    @Binding var isPresented: Bool
    
    let message: String
    let container: Container
    
    private var background: Color {
        Color.black.opacity(0.5)
    }
    
    var body: some View {
        container
            .overlay(isPresented ? background.ignoresSafeArea() : nil)
            .overlay(isPresented ? content : nil)
            .animation(.default, value: isPresented)
    }
    
    private var content: some View {
        VStack(spacing: 16) {
            Text(message)
            ProgressView()
        }
        .padding(24)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .clipped()
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 0)
    }
}

struct ProgressDialogPreviews: PreviewProvider {
    
    static var previews: some View {
        ProgressDialog(
            isPresented: .constant(true),
            message: "Please wait…",
            container: Rectangle().foregroundColor(Color.systemBackground)
        )
    }
}

extension View {
    
    func progressDialog(isPresented: Binding<Bool>, message: String) -> some View {
        ProgressDialog(isPresented: isPresented, message: message, container: self)
    }
}
