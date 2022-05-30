import StoreKit

typealias Subscription = Product

extension Product {
    
    var displayPeriodUnit: String? {
        switch subscription?.subscriptionPeriod.unit {
        case .day:
            return "day"
        case .week:
            return "weeek"
        case .month:
            return "month"
        case .year:
            return "year"
        default:
            return nil
        }
    }
}
