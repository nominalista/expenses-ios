import FirebaseFirestore

class AppAccountToken {
    
    enum AppAccountTokenError: Error {
        case unauthenticated
    }
    
    private var firestore: Firestore {
        Firestore.firestore()
    }
    
    private var userID: String {
        get throws {
            guard let userID = AuthState.shared.user?.id else {
                throw AppAccountTokenError.unauthenticated
            }
            return userID
        }
    }
    
    func fetchOrGenerate() async throws -> UUID {
        let snapshot = try await firestore
            .collection("subscriptions")
            .document(userID)
            .getDocument()
        
        guard
            let appleSubscription = snapshot.get("appleSubscription") as? [String: Any],
            let appAccountTokenString = appleSubscription["appAccountToken"] as? String,
            let appAccountToken = UUID(uuidString: appAccountTokenString)
        else {
            return UUID()
        }
        
        return appAccountToken
    }
}
