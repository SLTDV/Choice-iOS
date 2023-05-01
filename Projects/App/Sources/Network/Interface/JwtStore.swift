protocol JwtStore {
    func saveToken(type: KeyChainAccountType, token: String)
    func getToken(type: KeyChainAccountType) -> String
    func deleteAll()
    func setToken(data: ManageTokenModel)
}

enum KeyChainAccountType: String {
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
    case accessExpriedTime = "accessExpriedTime"
    case refreshExpriedTime = "refreshExpriedTime"
}

enum KeyChainError: Error {
    case noData
}
