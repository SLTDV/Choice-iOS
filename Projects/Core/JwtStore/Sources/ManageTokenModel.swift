import Foundation

public struct ManageTokenModel: Codable {
    public var accessToken: String
    public var refreshToken: String
    public var accessExpiredTime: String
    public var refreshExpiredTime: String
}
