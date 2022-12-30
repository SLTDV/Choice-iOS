import Foundation

struct CommentModel: Codable {
    var authorname: String
    var comment : [CommentData]
}

struct CommentData: Codable {
    var nickname: String
    var content: String
}
