//
//  WelcomeViewModel.swift
//  Expenses
//
//  Created by Nominalista on 07/12/2021.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn
import FirebaseAuth
import SwiftUI

class WelcomeViewModel: NSObject, ObservableObject {

    func signIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID,
              let viewController = getPresentingViewController() else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn
            .sharedInstance
            .signIn(
                with: config,
                presenting: viewController
            ) { user, error in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let authentication = user?.authentication,
                      let idToken = authentication.idToken else { return }
                
                let credential = GoogleAuthProvider.credential(
                    withIDToken: idToken,
                    accessToken: authentication.accessToken
                )
                
                AuthState.shared.logIn(with: credential) { error in
                    if let error = error {
                        print(error)
                        return
                    }
                }
            }
    }
    
    private func getPresentingViewController() -> UIViewController? {
        let windowScene: UIWindowScene? = UIApplication.shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first { $0 is UIWindowScene }
            .flatMap { $0 as? UIWindowScene }
        
        return windowScene?.windows
            .first(where: \.isKeyWindow)?
            .rootViewController
    }
}
