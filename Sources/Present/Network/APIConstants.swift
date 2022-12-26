import Foundation

final class APIConstants {
    static let baseURL = "http://10.82.17.76:8090"
    
    //post
    static let findNewestPost = baseURL + "/post/"
    static let createPost = baseURL + "/post/"
    static let plusVoteNumbers = baseURL + "/post/"
    static let findAllBestPost = baseURL + "/post/list"
}
