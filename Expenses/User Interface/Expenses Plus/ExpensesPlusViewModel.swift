import Combine
import Foundation

@MainActor class ExpensesPlusViewModel: ObservableObject {
    
    @Published var subscriptions: [Subscription] = []
    @Published var selectedSubscriptionID: String?
    
    @Published var isLoading = false
    @Published var isPurchasing = false
    
    let dismissPublisher = PassthroughSubject<Void, Never>()
    let failedPurchasePublisher = PassthroughSubject<Void, Never>()
    
    private var subscriptionManager: SubscriptionManager {
        SubscriptionManager.shared
    }
    
    init() {
        isLoading = true
        
        Task {
            do {
                subscriptions = try await subscriptionManager.requestSubscriptions()
                selectedSubscriptionID = subscriptions.first?.id
                isLoading = false
            } catch let error {
                print("Failed to fetch subscriptions (\(error)).")
            }
        }
    }
    
    func purchase() {
        guard let subscription = subscriptions.first(
            where: { $0.id == selectedSubscriptionID }
        ) else { return }

        isPurchasing = true
        
        Task {
            do {
                let purchased = try await subscriptionManager.purchase(subscription: subscription)
                if purchased {
                    print("Succeeded to purchase subscription.")
                    dismissPublisher.send()
                }
            } catch let error {
                print("Failed to purchase subscription (\(error)).")
                failedPurchasePublisher.send()
            }
            
            isPurchasing = false
        }
    }
    
    func select(subscriptionWithID id: String) {
        selectedSubscriptionID = id
    }
}
