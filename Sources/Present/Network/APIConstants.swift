import Foundation

final class APIConstants {
    static let baseURL = "http://10.82.17.77:8080"
    
    //signUp
    static let signInURL = baseURL + "/auth/signin"
    //SignIn
    static let signUpURL = baseURL + "/auth/signUp"
    
    //post
    static let findNewestPostURL = baseURL + "/post/"
    static let createPostURL = baseURL + "/post/"
    static let plusVoteNumbersURL = baseURL + "/post/"
    static let imageUploadURL = baseURL + "/image/"
    static let findAllBestPostURL = baseURL + "/post/list"
}
