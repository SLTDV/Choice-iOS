import NetworkService
import Alamofire

enum SignInTarget {
    case requestSignIn(RequestSignInModel)
}

extension SignInTarget: BaseRouter {
    var baseURL: String {
        return "https://server.choice-time.com/"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .requestSignIn: return .post
        }
    }
    
    var path: String {
        switch self {
        case .requestSignIn:
            return "auth/signin"
        }
    }
        
    var parameters: NetworkService.RequestParams {
            switch self {
            case .requestSignIn(let body):
                let body: [String: String] = [
                    "phoneNumber" : body.phoneNumber,
                    "password" : body.password,
                    "fcmToken" : body.fcmToken!,
                ]
                return .requestBody(body)
        }
    }
        
    var multipart: Alamofire.MultipartFormData {
        return MultipartFormData()
    }
    
    var header: NetworkService.HeaderType {
        return .notHeader
    }
}
