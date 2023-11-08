struct AddPostModel: Codable {
    var firstUploadImageUrl: String
    var secondUploadImageUrl: String
}

struct RequestVoteModel {
    let idx: Int
    let choice: Int
}
