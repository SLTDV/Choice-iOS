import Foundation
import Alamofire
import Shared

public class JwtRequestInterceptor: RequestInterceptor, JwtStore {
    private let jwtStore: JwtStore
    private let keychain = KeyChain()
    
    public init(jwtStore: JwtStore) {
        self.jwtStore = jwtStore
    }
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(APIConstants.baseURL) == true else {
            completion(.success(urlRequest))
            return
        }
        var urlRequest = urlRequest
        let accessToken = getToken(type: .accessToken)
        urlRequest.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
    
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let accessExpiredTime = getToken(type: .accessExpriedTime).getStringToDate()
        if accessExpiredTime.compare(Date().addingTimeInterval(32400)) == .orderedAscending {
            completion(.doNotRetryWithError(error))
            return
        }
        
        let url = APIConstants.reissueURL
        let headers: HTTPHeaders = ["RefreshToken" : getToken(type: .refreshToken)]
        
        AF.request(url, method: .patch,
                   encoding: JSONEncoding.default,
                   headers: headers).responseDecodable(of: ManageTokenModel.self) { [weak self] response in
            print("retry status code = \(response.response?.statusCode)")
            switch response.result {
            case .success(let data):
                self?.deleteAll()
                self?.setToken(data: data)
                completion(.retry)
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
        }
    }
}


extension JwtRequestInterceptor {
    public func saveToken(type: KeyChainAccountType, token: String) {
        keychain.save(type: type, token: token)
    }
    
    public func getToken(type: KeyChainAccountType) -> String {
        do {
            return try keychain.read(type: type)
        } catch {
            print("Failed to get token from Keychain: \(error)")
            return ""
        }
    }
    
    public func deleteAll() {
        jwtStore.deleteAll()
    }
    
    public func setToken(data: ManageTokenModel) {
        keychain.save(type: .accessToken, token: data.accessToken)
        keychain.save(type: .refreshToken, token: data.refreshToken)
        keychain.save(type: .accessExpriedTime, token: data.accessExpiredTime)
        keychain.save(type: .refreshExpriedTime, token: data.refreshExpiredTime)
    }
}
