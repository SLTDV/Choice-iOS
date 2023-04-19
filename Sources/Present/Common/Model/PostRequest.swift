import Foundation

struct PostRequest: Codable {
    var page: Int
    var size: Int = 10
}
