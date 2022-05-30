import Foundation

extension Wallet {
    
    static func myWallet(ownerID: String, ownerName: String) -> Wallet {
        Wallet(
            id: "",
            emoji: emojis.first!,
            name: "My Wallet",
            owner: User(id: ownerID, name: ownerName),
            contributors: [],
            authorizedUserIDs: [ownerID]
        )
    }
}
