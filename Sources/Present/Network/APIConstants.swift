import Foundation

final class APIConstants {
    static let baseURL = "http://172.20.10.4:80"
    
    //SignIn
    static let signInURL = baseURL + "/auth/signin"
    static let reissueURL = baseURL + "/auth/"
    
    //SignUp
    static let signUpURL = baseURL + "/auth/signup"
    
    //Post
    static let findNewestPostURL = baseURL + "/post/"
    static let createPostURL = baseURL + "/post/"
    static let plusVoteNumbersURL = baseURL + "/post/"
    static let findAllBestPostURL = baseURL + "/post/list"
    static let imageUploadURL = baseURL + "/image/"
    
    //Vote
    static let addVoteNumberURL = baseURL + "/post/add/"
}
