import Foundation

final class APIConstants {
    static let baseURL = "http:/10.82.17.76:80"
    
    //SignIn
    static let signInURL = baseURL + "/auth/signin"
    static let reissueURL = baseURL + "/auth/"
    static let logoutURL = baseURL + "/auth/"
    
    //SignUp
    static let signUpURL = baseURL + "/auth/signup"
    
    //Post
    static let findNewestPostURL = baseURL + "/post/"
    static let createPostURL = baseURL + "/post/"
    static let plusVoteNumbersURL = baseURL + "/post/"
    static let findAllBestPostURL = baseURL + "/post/list"
    static let detailPostURL = baseURL + "/post/"
    static let imageUploadURL = baseURL + "/image/"
    
    //Vote
    static let addVoteNumberURL = baseURL + "/post/add/"
    
    //Comment
    static let createCommentURL = baseURL + "/comment/"
    static let editCommentURL = baseURL + "/comment/"
    static let deleteCommentURL = baseURL + "/comment/"
    
    //Profile
    static let profileURL = baseURL + "/user/"
    static let changeNicknameURL = baseURL + "/user/"
    static let membershipWithdrawalURL = baseURL + "/user/"
}
