import FirebaseFirestore
import Combine

extension SubscriptionManager {
    
    struct Status {
        let isSubscribed: Bool
        let expiresAt: Date
    }
    
    private var firestore: Firestore {
        Firestore.firestore()
    }
    
    private var authState: AuthState {
        AuthState.shared
    }
    
    func observeStatusChange() {
        authState.$user
            .flatMap { [weak self] user -> AnyPublisher<Status?, Error> in
                if let self = self, let user = user {
                    return self.observeSubscriptionStatus(for: user)
                } else {
                    return Just(nil)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print("Failed to observe status change (\(error)).")
                }
            }, receiveValue: { [weak self] status in
                self?.status = status
            })
            .store(in: &cancellables)
    }
    
    private func observeSubscriptionStatus(
        for user: AuthState.User
    ) -> AnyPublisher<Status?, Error> {
        firestore
            .collection("subscriptions")
            .document(user.id)
            .publisher()
            .map { $0.statusOrNil }
            .eraseToAnyPublisher()
    }
}

private extension DocumentSnapshot {
    
    var statusOrNil: SubscriptionManager.Status? {
        guard
            let status = get("status") as? [String: Any],
            let isSubscribed = status["isSubscribed"] as? Bool,
            let expiresAtMillis = status["expiresAt"] as? Int
        else {
            return nil
        }
        
        return SubscriptionManager.Status(
            isSubscribed: isSubscribed,
            expiresAt: Date(timeIntervalSince1970: TimeInterval(expiresAtMillis / 1000))
        )
    }
}
