import Foundation

struct ManageTokenModel: Codable {
    var accessToken: String
    var refreshToken: String
    var accessExpiredTime: String
    var refreshExpiredTime: String
}
