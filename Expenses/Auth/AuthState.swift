//
//  AuthState.swift
//  Expenses
//
//  Created by Nominalista on 12/12/2021.
//

import Foundation
import FirebaseAuth

class AuthState: ObservableObject {
    
    static let shared = AuthState()
    
    var userID: String? {
        Auth.auth().currentUser?.uid
    }
    
    var userDisplayName: String? {
        Auth.auth().currentUser?.displayName
    }
    
    var userEmail: String? {
        Auth.auth().currentUser?.email
    }
    
    @Published var isUserLoggedIn = false
    
    func logIn(
        with credential: AuthCredential,
        completion: @escaping (Error?) -> Void
    ) {
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            self?.updateIsUserLoggedIn()
            completion(error)
        }
    }
    
    func logOut() {
        try? Auth.auth().signOut()
        updateIsUserLoggedIn()
    }
    
    func updateIsUserLoggedIn() {
        isUserLoggedIn = Auth.auth().currentUser != nil
    }
}
