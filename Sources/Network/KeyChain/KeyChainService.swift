import Foundation

protocol KeychainServiceProtocol {
    func saveToken(key: String, token: String)
    func getToken(key: String)
}

class KeyChainService: KeychainServiceProtocol {
    private let keychain = KeyChain()
    
    func saveToken(key: String, token: String) {
//        keychain.s
    }
    
    func getToken(key: String) {
        
    }
}
