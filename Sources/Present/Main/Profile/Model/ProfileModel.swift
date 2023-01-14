import Foundation

struct ProfileModel: Codable {
    var nickname: String
    var postList: [PostModel]?
}
