import Foundation

final class APIConstants {
    static let baseURL = "http://10.82.17.76:8090"
    
    //SignIn
    static let signInURL = baseURL + "/auth/signin"
    
    static let findNewestPost = baseURL + "/post/"
    static let findAllBestPost = baseURL + "/post/list"
    static let signUpURL = baseURL + "/auth/signUp"
}
