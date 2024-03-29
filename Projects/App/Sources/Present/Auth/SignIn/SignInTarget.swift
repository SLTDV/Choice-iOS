import NetworkService
import Alamofire

enum SignInTarget {
    case requestSignIn(RequestSignInModel)
}

extension SignInTarget: BaseRouter {
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var path: String {
        return "auth/signin"
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
