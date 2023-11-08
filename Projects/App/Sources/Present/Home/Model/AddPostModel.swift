struct AddPostModel: Codable {
    var firstUploadImageUrl: String
    var secondUploadImageUrl: String
}

struct VoteRequest {
    let idx: Int
    let choice: Int
}
