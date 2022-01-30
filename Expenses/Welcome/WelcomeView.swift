//
//  WelcomeView.swift
//  Expenses
//
//  Created by Nominalista on 07/12/2021.
//

import Foundation
import SwiftUI

struct WelcomeView: View {
    
    @ObservedObject var viewModel = WelcomeViewModel()
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                Spacer().frame(height: 120)
                
                Image("Logo")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(16)
                    .shadow(
                        color: .black.opacity(0.25),
                        radius: 4,
                        x: 0,
                        y: 2
                    )
                
                Spacer().frame(height: 32)
                
                Text("Welcome to Expenses")
                    .font(.title)
                    .environment(\.colorScheme, .dark)
                    .foregroundColor(Color(uiColor: .label))
                
                Spacer().frame(height: 4)
                
                Text("Simple budget tracker")
                    .font(.body)
                    .environment(\.colorScheme, .dark)
                    .foregroundColor(Color(uiColor: .label))
                
                Spacer()
                
                GoogleSignInButton {
                    viewModel.signIn()
                }
                
                Spacer().frame(height: 64)
            }
            
            Spacer()
        }
        .background(Color.brandPrimary)
        .preferredColorScheme(.dark)
    }
}

struct GoogleSignInButton: View {
    
    var action: (() -> Void)?
    
    var body: some View {
        Button {
            action?()
        } label: {
            HStack {
                Image("Google")
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Spacer().frame(width: 16)
                
                Text("Continue with Google")
                    .font(.system(.body).weight(.semibold))
            }
        }
        .padding()
        .frame(width: 260)
        .accentColor(Color(uiColor: .label))
        .background(Color(uiColor: .systemBackground))
        .preferredColorScheme(.light)
        .environment(\.colorScheme, .light)
        .clipShape(Capsule())
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
