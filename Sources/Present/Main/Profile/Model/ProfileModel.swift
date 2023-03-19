import Foundation

struct ProfileModel: Codable {
    var nickname: String
    var image: String
    var postList: [PostModel]?
}
