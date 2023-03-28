import Foundation

struct SignUpModel: Codable {
    static let share = SignUpModel()
    
    var email: String?
    var password: String?
    var nickname: String?
    var profileImgUrl: String?
}
