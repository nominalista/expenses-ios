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
            GIDSignIn.sharedInstance.configuration = configuration
            GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let user = result?.user {
                    let credential = GoogleAuthProvider.credential(
                        withIDToken: user.idToken!.tokenString,
                        accessToken: user.accessToken.tokenString
                    )
                    continuation.resume(returning: credential)
                } else {
                    continuation.resume(throwing: GoogleSignInError.unknown)
                }
            }
        }
    }
}
