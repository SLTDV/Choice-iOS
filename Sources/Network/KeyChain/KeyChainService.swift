import Foundation

protocol KeychainServiceProtocol {
    func saveToken(type: KeyChainAccountType, token: String)
    func getToken(type: KeyChainAccountType) -> String
    func deleteAll()
}

class KeyChainService: KeychainServiceProtocol {
    private let keychain: KeyChain
    
    init(keychain: KeyChain) {
        self.keychain = keychain
    }
    
    func saveToken(type: KeyChainAccountType, token: String) {
        keychain.save(type: type, token: token)
    }
    
    func getToken(type: KeyChainAccountType) -> String {
        do {
            return try keychain.read(type: type)
        } catch {
            print("Failed to get token from Keychain: \(error)")
            return ""
        }
    }
    
    func deleteAll() {
        keychain.deleteAll()
    }
}