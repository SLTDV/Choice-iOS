import Foundation

struct PostModel: Codable {
    var idx: Int
    var thumbnail: String
    var title: String
    var content: String
    var firstVotingOption: String
    var secondVotingOption: String
    var firstVotingCount: Int
    var secondVotingCount: Int
    var isVoting: Bool
    var participants: Int
    var commentCount: Int
}
