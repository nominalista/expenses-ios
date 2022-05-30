//
//  GoogleSignInHandler.swift
//  Expenses
//
//  Created by Nominalista on 19/02/2022.
//

import FirebaseAuth
import FirebaseCore
import Foundation
import GoogleSignIn
import UIKit

class GoogleSignInHandler {
    
    enum GoogleSignInError: Error {
        case unknown
    }
    
    private var configuration: GIDConfiguration {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("Unable to fetch client ID from FirebaseApp.")
        }
        return GIDConfiguration(clientID: clientID)
    }
    
    private var viewController: UIViewController {
        UIApplication.shared.rootViewController!
    }
    
    func requestCredential() async throws -> AuthCredential {
        try await withCheckedThrowingContinuation { continuation in 
            GIDSignIn.sharedInstance.signIn(
                with: configuration,
                presenting: viewController
            ) { user, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let user = user {
                    let credential = GoogleAuthProvider.credential(
                        withIDToken: user.authentication.idToken!,
                        accessToken: user.authentication.accessToken
                    )
                    continuation.resume(returning: credential)
                } else {
                    continuation.resume(throwing: GoogleSignInError.unknown)
                }
            }
        }
    }
}
