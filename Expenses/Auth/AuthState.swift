//
//  AuthState.swift
//  Expenses
//
//  Created by Nominalista on 12/12/2021.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFunctions
import GoogleSignIn

class AuthState: ObservableObject {
    
    struct User {
        let id: String
        let email: String?
        let displayName: String?
    }
    
    enum Error: Swift.Error {
        case unauthenticated
    }
    
    static let shared = AuthState()
    
    @Published var user: AuthState.User?
    
    private var auth: Auth {
        Auth.auth()
    }
    
    private var functions: Functions {
        Functions.functions()
    }
    
    private var listenerHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        user = auth.currentUser?.user
        listenerHandle = auth.addStateDidChangeListener { [weak self] _, user in
            if let user = user {
                self?.user = user.user
            } else {
                self?.user = nil
            }
        }
    }
    
    deinit {
        listenerHandle.map { auth.removeStateDidChangeListener($0) }
    }
    
    func requireUser() throws -> AuthState.User {
        guard let user = user else {
            throw Error.unauthenticated
        }
        return user
    }
    
    func signInWithApple() async -> Result<Void, Swift.Error> {
        do {
            let credential = try await AppleSignInHandler().requestCredential()
            try await auth.signIn(with: credential)
            return .success(())
        } catch let error {
            return .failure(error)
        }
    }
    
    func signInWithGoogle() async -> Result<Void, Swift.Error> {
        do {
            let credential = try await GoogleSignInHandler().requestCredential()
            try await auth.signIn(with: credential)
            return .success(())
        } catch let error {
            return .failure(error)
        }
    }
    
    func signOut() {
        try? auth.signOut()
    }
    
    func deleteUser() async throws {
        guard auth.currentUser != nil else {
            throw Error.unauthenticated
        }
        let _ = try await functions.httpsCallable("deleteUserWithData").call()
    }
}

private extension FirebaseAuth.User {
    
    var user: AuthState.User {
        AuthState.User(id: uid, email: email, displayName: displayName)
    }
}
