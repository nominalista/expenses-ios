//
//  WelcomeView.swift
//  Expenses
//
//  Created by Nominalista on 07/12/2021.
//

import Foundation
import SwiftUI

struct WelcomeView: View {
    
    @StateObject var viewModel: WelcomeViewModel
    
    @Environment(\.openURL) var openURL
        
    var body: some View {
        GeometryReader { geometry in
            VStack {
                header.frame(height: geometry.size.height / 2)
                Spacer()
                signInButtons
                Spacer().frame(height: 32)
                privacyPolicy
            }
        }
        .padding(32)
    }
    
    private var header: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .leading, spacing: 0) {
                Image.imgLogo
                    .resizable()
                    .frame(width: 64, height: 64)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
                
                Spacer().frame(height: 32)
                
                Text("Welcome to")
                    .font(.largeTitle.weight(.black))
                    .foregroundColor(.label)
                
                Text("Expenses")
                    .font(.largeTitle.weight(.black))
                    .foregroundColor(.brandPrimary)
                
                Spacer().frame(height: 8)
                
                Text("Simple budget tracker.")
                    .font(.title3)
                    .foregroundColor(.label)
                
                Spacer().frame(height: 48)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var signInButtons: some View {
        VStack(spacing: 0) {
            Text("Continue with")
                .font(.headline)
                .foregroundColor(.secondaryLabel)
            
            Spacer().frame(height: 16)
            
            SignInButton(
                image: .icApple24pt,
                title: "Apple",
                isSigningIn: $viewModel.isSigningInWithApple
            ) {
                viewModel.signInWithApple()
            }
            
            Spacer().frame(height: 16)
            
            SignInButton(
                image: .icGoogle24pt,
                title: "Google",
                isSigningIn: $viewModel.isSigningInWithGoogle
            ) {
                viewModel.signInWithGoogle()
            }
        }
    }
    
    private var privacyPolicy: some View {
        Group {
            Text("By continuing, you agree to the\n")
                .font(.subheadline)
                .foregroundColor(.secondaryLabel)
            + Text("Privacy Policy")
                .font(.subheadline.weight(.medium))
                .foregroundColor(.brandPrimary)
            + Text(".")
                .font(.subheadline)
                .foregroundColor(.secondaryLabel)
        }
        .multilineTextAlignment(.center)
        .onTapGesture { openURL(privacyPolicyURL) }
    }
}

struct SignInButton: View {
    
    var image: Image
    var title: String
    var isSigningIn: Binding<Bool>
    var didTap: () -> Void
    
    var body: some View {
        Button {
            didTap()
        } label: {
            ZStack {
                HStack {
                    image
                    Spacer()
                }
                HStack {
                    Spacer()
                    if isSigningIn.wrappedValue {
                        ProgressView()
                    } else {
                        Text(title)
                    }
                    Spacer()
                }
            }
        }
        .buttonStyle(SignInButtonStyle())
    }
}

struct SignInButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.body.weight(.semibold))
            .padding(16)
            .accentColor(.label)
            .backgroundColor(.secondarySystemBackground)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.5 : 1.0)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(viewModel: .preview)
    }
}
