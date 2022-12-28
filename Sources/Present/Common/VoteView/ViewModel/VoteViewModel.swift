import Foundation
import Alamofire

protocol VotingCountProtocol: AnyObject {
    var firstVotingCountData: Int{ get set }
    var secondVotingCountData: Int { get set }
}

class VoteViewModel {
    weak var delegate: VotingCountProtocol?
    
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
        .responseDecodable(of: VoteModel.self) { [weak self] response in
            switch response.result {
            case .success:
                self?.delegate?.firstVotingCountData = response.value?.firstVotingCount ?? 0
                self?.delegate?.secondVotingCountData = response.value?.secondVotingCount ?? 0
                print(self?.delegate?.secondVotingCountData)
                
            case .failure(let error):
                print("vote error = \(error.localizedDescription)")
            }
        }
        
    }
}
