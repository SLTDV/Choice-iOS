import UIKit

class AddPostModel: Codable {
    var title: String?
    var content: String?
    var thumbnail: Data?
    var firstVotingOption: String?
    var secondVotingOtion: String?
}
