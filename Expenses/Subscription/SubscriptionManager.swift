import Combine
import FirebaseFirestore
import FirebaseFunctions
import StoreKit

class SubscriptionManager: NSObject, ObservableObject {
    
    enum SubscriptionError: Error {
        case failedVerification
    }
    
    static var shared = SubscriptionManager()
    
    @Published var status: SubscriptionManager.Status?
    
    var cancellables: Set<AnyCancellable> = []
    
    private var subscriptionIDs = Set(["monthly_subscription", "yearly_subscription"])
    
    private var transactionUpdateListener: Task<Void, Error>?
        
    private override init() {
        super.init()
        observeStatusChange()
    }
    
    func listenForTransacionUpdates() {
        transactionUpdateListener?.cancel()
        transactionUpdateListener = Task.detached {
            for await result in StoreKit.Transaction.updates {
                do {
                    print("Transaction update received. Verifying transaction…")
                    
                    let transaction = try self.checkVerified(result)
                    print("Verification completed. Updating subscription status…")
                    
                    try await self.updateSubscriptionStatus(transaction: transaction)
                    print("Subscription status updated. Finishing transaction…")
                    
                    await transaction.finish()
                } catch let error {
                    print("Failed to process transaction update (\(error)).")
                }
            }
        }
    }
    
    deinit {
        transactionUpdateListener?.cancel()
    }
    
    func requestSubscriptions() async throws -> [Subscription] {
        try await Product.products(for: subscriptionIDs)
    }
    
    func purchase(subscription: Subscription) async throws -> Bool {
        print("Purchasing \(subscription.id)…")
        
        let appAccountToken = try await AppAccountToken().fetchOrGenerate()
        
        let options: Set<Product.PurchaseOption> = .init([.appAccountToken(appAccountToken)])
        let result = try await subscription.purchase(options: options)
            
        switch result {
        case .success(let verification):
            print("Purchase succeeded. Verifying transaction…")
            
            let transaction = try checkVerified(verification)
            print("Verification completed. Updating subscription status…")
            
            try await updateSubscriptionStatus(transaction: transaction)
            print("Subscription status updated. Finishing transaction…")
            
            await transaction.finish()
            
            return true
            
        case .userCancelled:
            print("Purchase cancelled by user.")
            return false
            
        case .pending:
            print("Purchase is pending some user action.")
            return false
            
        default:
            return false
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw SubscriptionError.failedVerification
        case .verified(let transaction):
            return transaction
        }
    }
}

// MARK: Cloud Functions

extension SubscriptionManager {
    
    private var functions: Functions {
        Functions.functions()
    }
        
    private func updateSubscriptionStatus(transaction: StoreKit.Transaction) async throws {
        let parameters = ["originalTransactionId": transaction.originalID]
        let _ = try await functions.httpsCallable("appleUpdateSubscriptionStatus").call(parameters)
    }
}
