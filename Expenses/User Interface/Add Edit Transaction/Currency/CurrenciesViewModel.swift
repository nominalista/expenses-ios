import Combine
import Foundation

class CurrenciesViewModel: ObservableObject {
    
    @Published var currencies: [Currency] = Currency.allCases
    @Published var query = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $query
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] query in
                guard !query.isEmpty && !query.isBlank else {
                    self?.currencies = Currency.allCases
                    return
                }
                
                self?.currencies = Currency.allCases.filter { currency in
                    let sanitizedQuery = query.lowercased()
                    return currency.code.lowercased().contains(sanitizedQuery) ||
                    currency.name.lowercased().contains(sanitizedQuery)
                }
            }
            .store(in: &cancellables)
    }
}
