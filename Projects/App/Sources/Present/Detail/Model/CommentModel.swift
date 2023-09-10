struct CommentModel: Codable {
    var page: Int
    var size: Int
    var writer: String
    var image: String?
    var isMine: Bool
    var commentList : [CommentList]
}

struct CommentList: Codable {
    var idx: Int
    var nickname: String
    var content: String
    var profileImageUrl: String?
    var isMine: Bool
}
