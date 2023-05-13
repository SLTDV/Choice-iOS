import Foundation
import Alamofire
import Shared

public class JwtRequestInterceptor: RequestInterceptor {
    private let jwtStore: JwtStore
    
    public init(jwtStore: JwtStore) {
        self.jwtStore = jwtStore
    }
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(APIConstants.baseURL) == true else {
            completion(.success(urlRequest))
            return
        }
        
        print("adapt!!")
        print(Date().addingTimeInterval(32400))
        var urlRequest = urlRequest
        let accessToken = jwtStore.getToken(type: .accessToken)
        urlRequest.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
    
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry!")
        let accessExpiredTime = jwtStore.getToken(type: .accessExpriedTime).getStringToDate()
        if accessExpiredTime.compare(Date().addingTimeInterval(32400)) == .orderedAscending {
            completion(.doNotRetryWithError(error))
            return
        }
        
        let url = APIConstants.reissueURL
        let headers: HTTPHeaders = ["RefreshToken" : jwtStore.getToken(type: .refreshToken)]
        
        AF.request(url, method: .patch,
                   encoding: JSONEncoding.default,
                   headers: headers).responseDecodable(of: ManageTokenModel.self) { [weak self] response in
            print("retry status code = \(response.response?.statusCode)")
            switch response.result {
            case .success(let data):
                self?.jwtStore.deleteAll()
                self?.jwtStore.setToken(data: data)
                completion(.retry)
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
