import Foundation
import Alamofire

final class JwtRequestInterceptor: RequestInterceptor {
    let tkService = KeyChainService(keychain: KeyChain.shared)
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(APIConstants.baseURL) == true else {
            completion(.success(urlRequest))
            return
        }
        var urlRequest = urlRequest
        do {
            let accessToken = tkService.getToken(type: .accessToken)
            urlRequest.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            completion(.success(urlRequest))
        } catch {
            completion(.failure(error))
        }
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        let url = APIConstants.reissueURL
        let headers: HTTPHeaders = ["RefreshToken" : tkService.getToken(type: .refreshToken)]
        
        AF.request(url, method: .patch, encoding: JSONEncoding.default, headers: headers).responseData { [weak self] response in
            print("retry status code = \(response.response?.statusCode)")
            switch response.result {
            case .success(let data):
                self?.tkService.deleteAll()
                let decodeResult = try? JSONDecoder().decode(ManageTokenModel.self, from: data)
                self?.tkService.saveToken(type: .accessToken, token: decodeResult?.accessToken ?? "")
                completion(.retry)
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
