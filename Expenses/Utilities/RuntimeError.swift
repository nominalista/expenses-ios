import Foundation

struct RuntimeError: Error {
    
    let message: String
    
    var localizedDescription: String {
        message
    }
}
