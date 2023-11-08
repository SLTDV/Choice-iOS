struct PostModel: Codable {
    var page: Int
    var size: Int
    var postList: [PostList]
}

class PostList: Codable {
    var idx: Int
    var firstImageUrl: String
    var secondImageUrl: String
    var title: String
    var content: String
    var firstVotingOption: String
    var secondVotingOption: String
    var firstVotingCount: Int
    var secondVotingCount: Int
    var votingState: Int
    var participants: Int
    var commentCount: Int
}

struct RequestPostModel {
    var type: MenuOptionType = .findBestPostData
    var page: Int
    var size: Int = 5
}
