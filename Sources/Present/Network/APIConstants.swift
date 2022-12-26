import Foundation

final class APIConstants {
    static let baseURL = "http://10.82.17.77:8080"
    
    //post
    static let findNewestPost = baseURL + "/post/"
    static let createPost = baseURL + "/post/"
    static let plusVoteNumbers = baseURL + "/post/"
    static let findAllBestPost = baseURL + "/post/list"
}
