import Foundation

struct CommentModel: Codable {
    var writer: String
    var image: String
    var comment : [CommentData]
}

struct CommentData: Codable {
    var idx: Int
    var nickname: String
    var content: String
    var image: String
}
