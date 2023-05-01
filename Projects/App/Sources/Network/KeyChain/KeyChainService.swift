import Foundation

struct KeyChainService: JwtStore {
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
    
    func setToken(data: ManageTokenModel) {
        keychain.save(type: .accessToken, token: data.accessToken)
        keychain.save(type: .refreshToken, token: data.refreshToken)
        keychain.save(type: .accessExpriedTime, token: data.accessExpiredTime)
        keychain.save(type: .refreshExpriedTime, token: data.refreshExpiredTime)
    }
}
