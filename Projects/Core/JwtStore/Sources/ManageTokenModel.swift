import Foundation

public struct ManageTokenModel: Codable {
    var accessToken: String
    var refreshToken: String
    var accessExpiredTime: String
    var refreshExpiredTime: String
}
