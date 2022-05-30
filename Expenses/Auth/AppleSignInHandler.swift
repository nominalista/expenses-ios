//
//  AppleSignInHandler.swift
//  Expenses
//
//  Created by Nominalista on 15/02/2022.
//

import AuthenticationServices
import CryptoKit
import FirebaseAuth
import Foundation

class AppleSignInHandler: NSObject {
    
    private var currentContinuation: CheckedContinuation<String, Error>?
    
    func requestCredential() async throws -> AuthCredential {
        let nonce = generateRandomNonceString()
        let appleIDTokenString = try await requestAppleIDTokenString(nonce: nonce)
        return OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: appleIDTokenString,
            rawNonce: nonce
        )
    }
    
    private func requestAppleIDTokenString(nonce: String) async throws -> String {
        guard currentContinuation == nil else {
            fatalError("Trying to request Apple ID token for a second time.")
        }
        
        let appleIDTokenString: String = try await withCheckedThrowingContinuation { continuation in
            currentContinuation = continuation
            
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = nonce.sha256
                        
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
        
        currentContinuation = nil
        
        return appleIDTokenString
    }

    private func generateRandomNonceString(length: Int = 32) -> String {
        let charset: [Character] = Array(
            "0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._"
        )
        
        var result = ""
        var remainingLength = length
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                guard errorCode == errSecSuccess else {
                    fatalError(
                        "Unable to generate nonce. " +
                        "SecRandomCopyBytes failed with      \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength != 0 && random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AppleSignInHandler: ASAuthorizationControllerDelegate {
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("Unable to fetch Apple ID credential.")
            return
        }
        guard let appleIDToken = credential.identityToken,
              let appleIDTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to fetch identity token.")
            return
        }
        currentContinuation?.resume(returning: appleIDTokenString)
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        currentContinuation?.resume(throwing: error)
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension AppleSignInHandler: ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.rootWindow!
    }
}

private extension String {
    
    var sha256: String {
        let data = Data(utf8)
        let hashedData = SHA256.hash(data: data)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
}
