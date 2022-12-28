import Foundation
import Alamofire

class VoteViewModel {
    func votePost(idx: Int, choice: Int) {
        let url = APIConstants.addVoteNumberURL + "\(idx)"
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        let params = [
            "choice" : choice
        ] as Dictionary
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: headers,
                   interceptor: JwtRequestInterceptor())
        .validate()
        .responseData { [weak self] response in
            switch response.result {
            case .success(let data):
                print(response.response?.statusCode)
                
            case .failure(let error):
                print("vote error = \(error.localizedDescription)")
            }
        }
        
    }
}
