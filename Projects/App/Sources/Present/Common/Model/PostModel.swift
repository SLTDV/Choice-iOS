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
    
    init(idx: Int = 0,
         firstImageUrl: String = "",
         secondImageUrl: String = "",
         title: String = "",
         content: String = "",
         firstVotingOption: String = "",
         secondVotingOption: String = "",
         firstVotingCount: Int = 0,
         secondVotingCount: Int = 0,
         votingState: Int = 0,
         participants: Int = 0,
         commentCount: Int = 0
    ) {
        self.idx = idx
        self.firstImageUrl = firstImageUrl
        self.secondImageUrl = secondImageUrl
        self.title = title
        self.content = content
        self.firstVotingOption = firstVotingOption
        self.secondVotingOption = secondVotingOption
        self.firstVotingCount = firstVotingCount
        self.secondVotingCount = secondVotingCount
        self.votingState = votingState
        self.participants = participants
        self.commentCount = commentCount
    }
}

struct RequestPostModel {
    var type: MenuOptionType = .findBestPostData
    var page: Int
    var size: Int = 5
}
