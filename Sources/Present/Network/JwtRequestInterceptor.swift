import Foundation
import Alamofire

final class JwtRequestInterceptor: RequestInterceptor {
    let tk = KeyChain()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix("http://10.82.17.76:80") == true,
              let accessToken = tk.read(key: "accessToken") else {
            completion(.success(urlRequest))
            return
        }
        var urlRequest = urlRequest
        urlRequest.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 403 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        let url = APIConstants.reissueURL
        let headers: HTTPHeaders = ["RefreshToken" : tk.read(key: "refreshToken") ?? .init()]
        
        AF.request(url, method: .patch, encoding: JSONEncoding.default, headers: headers).responseData { [weak self] response in
            print("retry status code = \(response.response?.statusCode)")
            switch response.result {
            case .success(let tokenData):
                self?.tk.deleteAll()
                
                if let refreshToken = (try? JSONSerialization.jsonObject(with: tokenData, options: []) as? [String: Any])? ["refreshToken"] as? String {
                    self?.tk.create(key: "refreshToken", token: refreshToken)
                }
                
                if let accessToken = (try? JSONSerialization.jsonObject(with: tokenData, options: []) as? [String: Any])? ["accessToken"] as? String {
                    self?.tk.create(key: "accessToken", token: accessToken)
                }
                completion(.retry)
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
