import Foundation

struct SignInModel: Codable {
    var accessToken: String
    var refreshToken: String
    var expiredAt: String
}
