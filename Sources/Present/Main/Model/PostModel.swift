import Foundation

final class PostModel: Codable {
    var idx: Int
    var thumbnail: String
    var title: String
    var content: String
    var firstVotingOption: String
    var secondVotingOption: String
    var firstVotingCount: Int
    var secondVotingCount: Int
}
