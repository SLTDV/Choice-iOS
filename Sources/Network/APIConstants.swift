import Foundation

struct APIConstants {
    static let baseURL = "https://port-0-choice-backend-p8xrq2mlfhw9efx.sel3.cloudtype.app/8080"
    
    //SignIn
    static let signInURL = baseURL + "/auth/signin"
    static let reissueURL = baseURL + "/auth"
    static let logoutURL = baseURL + "/auth"
    
    //SignUp
    static let signUpURL = baseURL + "/auth/signup"
    static let emailDuplicationURL = baseURL + "/auth/duplication"
    
    //Post
    static let findNewestPostURL = baseURL + "/post"
    static let createPostURL = baseURL + "/post"
    static let plusVoteNumbersURL = baseURL + "/post"
    static let findAllBestPostURL = baseURL + "/post/list"
    static let detailPostURL = baseURL + "/post/"
    static let deletePostURL = baseURL + "/post/"
    static let postImageUploadURL = baseURL + "/image"
    
    //Vote
    static let addVoteNumberURL = baseURL + "/post/vote/"
    
    //Comment
    static let createCommentURL = baseURL + "/comment/"
    static let editCommentURL = baseURL + "/comment"
    static let deleteCommentURL = baseURL + "/comment"
    
    //Profile
    static let profileURL = baseURL + "/user"
    static let changeNicknameURL = baseURL + "/user"
    static let membershipWithdrawalURL = baseURL + "/user"
    static let changeProfileImageURL = baseURL + "/user/image"
    static let profileImageUploadURL = baseURL + "/image/profile"
    
    private init() {}
}
