struct CommentModel: Codable {
    var page: Int
    var size: Int
    var writer: String
    var image: String?
    var isMine: Bool
    var commentList : [CommentList]
    
    init(page: Int = 0,
         size: Int = 0,
         writer: String = "",
         image: String? = nil,
         isMine: Bool = false,
         commentList: [CommentList] = []
    ) {
        self.page = page
        self.size = size
        self.writer = writer
        self.image = image
        self.isMine = isMine
        self.commentList = commentList
    }
}

struct CommentList: Codable {
    var idx: Int
    var nickname: String
    var content: String
    var profileImageUrl: String?
    var isMine: Bool
}
