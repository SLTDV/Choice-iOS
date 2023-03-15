import Foundation

struct PostModel: Codable {
    var idx: Int
    var firstImageUrl: String
    var secondImageUrl: String
    var title: String
    var content: String
    var firstVotingOption: String
    var secondVotingOption: String
    var firstVotingCount: Int
    var secondVotingCount: Int
    var voting: Int
    var participants: Int
    var commentCount: Int
}
