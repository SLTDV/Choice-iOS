import Foundation

struct CommentModel: Codable {
    var authorname: String
    var comment : [CommentData]
}

struct CommentData: Codable {
    var idx: Int
    var nickname: String
    var content: String
}
