import Foundation

final class APIConstants {
    static let baseURL = "http://3.39.176.242:8080"
    
    //SignIn
    static let signInURL = baseURL + "/auth/signin"
    static let reissueURL = baseURL + "/auth/"
    
    //SignUp
    static let signUpURL = baseURL + "/auth/signup"
    
    //Post
    static let findNewestPostURL = baseURL + "/post/"
    static let createPostURL = baseURL + "/post/"
    static let plusVoteNumbersURL = baseURL + "/post/"
    static let imageUploadURL = baseURL + "/image/"
    static let findAllBestPostURL = baseURL + "/post/list"
    
    //Vote
    static let addVoteNumberURL = baseURL + "/post/add/"
}
