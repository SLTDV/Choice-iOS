import Foundation

public struct APIConstants {
    public static let baseURL = "https://www.choice-time.com/"
    
    //SignIn
    public static let signInURL = baseURL + "auth/signin"
    public static let reissueURL = baseURL + "auth"
    public static let logoutURL = baseURL + "auth"
    
    //SignUp
    public static let signUpURL = baseURL + "auth/signup"
    public static let emailDuplicationURL = baseURL + "auth/duplication"
    public static let certificationRequestURL = baseURL + "auth/phone"
    public static let checkAuthCodeURL = baseURL + "auth/phone"
    
    //Post
    public static let findNewestPostURL = baseURL + "post"
    public static let createPostURL = baseURL + "post"
    public static let plusVoteNumbersURL = baseURL + "post"
    public static let findAllBestPostURL = baseURL + "post/list"
    public static let detailPostURL = baseURL + "post/"
    public static let deletePostURL = baseURL + "post/"
    public static let postImageUploadURL = baseURL + "image"
    
    //Vote
    public static let addVoteNumberURL = baseURL + "post/vote/"
    
    //Comment
    public static let createCommentURL = baseURL + "comment/"
    public static let deleteCommentURL = baseURL + "comment/"
    
    //Profile
    public static let profileURL = baseURL + "user"
    public static let changeNicknameURL = baseURL + "user"
    public static let membershipWithdrawalURL = baseURL + "user"
    public static let changeProfileImageURL = baseURL + "user/image"
    public static let profileImageUploadURL = baseURL + "image/profile"
    
    private init() {}
}
