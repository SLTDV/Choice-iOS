import NetworkService
import Alamofire

enum HomeTarget {
    case requestPostData(RequestPostModel)
    case requestToVote(RequestVoteModel)
}

extension HomeTarget: BaseRouter { 
    var method: Alamofire.HTTPMethod {
        switch self {
        case .requestPostData: return .get
        case .requestToVote: return .post
        }
    }
    
    var path: String {
        switch self {
        case .requestPostData(let req):
            switch req.type {
            case .findBestPostData:
                return "post/list"
            case .findNewestPostData:
                return "post"
            }
        case .requestToVote(let req):
            return "post/vote/\(req.idx)"
        }
    }
    
    var parameters: NetworkService.RequestParams {
        switch self {
        case .requestPostData(let query):
            let query: [String: Int] = [
                "page": query.page,
                "size": query.size
            ]
            return .query(query)
        case .requestToVote(let body):
            let body: [String: Int] = [
                "choice": body.choice
            ]
            return .requestBody(body)
        }
    }
    
    var multipart: Alamofire.MultipartFormData {
        return MultipartFormData()
    }
    
    var header: NetworkService.HeaderType {
        return .withToken
    }
}
