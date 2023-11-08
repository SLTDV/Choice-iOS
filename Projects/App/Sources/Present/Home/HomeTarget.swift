import Foundation
import NetworkService
import Alamofire

enum HomeTarget {
    case requestPostData
    case requestToVote(VoteRequest)
}


extension HomeTarget: BaseRouter {
    var baseURL: String {
        return "https://server.choice-time.com/"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .requestPostData: return .get
        case .requestToVote: return .post
        }
    }
    
    var path: String {
        switch self {
        case .requestPostData:
            return "post"
        case .requestToVote(let req):
            return "post/vote/\(req.idx)"
        }
    }
    
    var parameters: NetworkService.RequestParams {
        switch self {
        case .requestToVote(let body):
            let body: [String: Int] = [
                "choie": body.choice
            ]
            return .requestBody(body)
        default: return .requestPlain
        }
    }
    
    var multipart: Alamofire.MultipartFormData {
        return MultipartFormData()
    }
    
    var header: NetworkService.HeaderType {
        return .withToken
    }
}
