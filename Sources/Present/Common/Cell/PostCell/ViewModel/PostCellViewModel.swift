import UIKit
import Alamofire

final class PostCellViewModel: BaseViewModel {
    func callToAddVoteNumber(idx: Int, choice: Int) {
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
        .responseData(emptyResponseCodes: [200, 201, 204]) { response in
            switch response.result {
            case .success(let data):
                let decodeResponse = try? JSONDecoder().decode(VoteModel.self, from: data)
            case .failure(let error):
                print("error = \(error.localizedDescription)")
            }
        }
    }
}
