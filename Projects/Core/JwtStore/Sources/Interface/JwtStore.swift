public protocol JwtStore {
    func saveToken(type: KeyChainAccountType, token: String)
    func getToken(type: KeyChainAccountType) -> String
    func deleteAll()
    func setToken(data: ManageTokenModel)
}

public enum KeyChainAccountType: String {
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
    case accessExpiredTime = "accessExpiredTime"
    case refreshExpiredTime = "refreshExpiredTime"
}

public enum KeyChainError: Error {
    case noData
}
