import Foundation

final class APIConstants {
    static let baseURL = "http://10.82.17.76:8090"
    
    //signIn
    static let signInURL = baseURL + "/auth/signin"
    static let reissueURL = baseURL + "/auth/"
    
    //SignUp
    static let signUpURL = baseURL + "/auth/signup"
    
    //post
    static let findNewestPostURL = baseURL + "/post/"
    static let createPostURL = baseURL + "/post/"
    static let plusVoteNumbersURL = baseURL + "/post/"
    static let imageUploadURL = baseURL + "/image/"
    static let findAllBestPostURL = baseURL + "/post/list"
    
    //vote
    static let addVoteNumberURL = baseURL + "/post/add/"
}
