import Foundation
import Alamofire
import JwtStore

class JwtRequestInterceptor: RequestInterceptor {
    let keyChainService = KeyChainService(keychain: KeyChain())
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(APIConstants.baseURL) == true else {
            completion(.success(urlRequest))
            return
        }
        var urlRequest = urlRequest
        let accessToken = keyChainService.getToken(type: .accessToken)
        urlRequest.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let accessExpiredTime = keyChainService.getToken(type: .accessExpriedTime).getStringToDate()
        if accessExpiredTime.compare(Date().addingTimeInterval(-10800)) == .orderedDescending {
            completion(.doNotRetryWithError(error))
            return
        }
        
        let url = APIConstants.reissueURL
        let headers: HTTPHeaders = ["RefreshToken" : keyChainService.getToken(type: .refreshToken)]
        
        AF.request(url, method: .patch,
                   encoding: JSONEncoding.default,
                   headers: headers).responseDecodable(of: ManageTokenModel.self) { [weak self] response in
            print("retry status code = \(response.response?.statusCode)")
            switch response.result {
            case .success(let data):
                self?.keyChainService.deleteAll()
                self?.keyChainService.setToken(data: data)
                completion(.retry)
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
