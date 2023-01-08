import Foundation

struct ProfileModel: Codable {
    var nickName: String
    var postList: [PostModel]
}

//struct PostList: Codable {
//    var idx: String
//    var thumbnail: String
//    var title: String
//    var content: String
//}
