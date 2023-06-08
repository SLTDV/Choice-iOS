import Foundation
import Shared
import JwtStore
import Alamofire

class PhoneNumberAuthViewModel: BaseViewModel {
    let container = AppDelegate.container.resolve(JwtStore.self)!
    
    func requestAuthNumber(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        let url = APIConstants.certificationRequestURL
        
        let phoneNumberItem = URLQueryItem(name: "phoneNumber", value: phoneNumber)
        
        var components = URLComponents(string: url)
        components?.queryItems = [phoneNumberItem]
        
        AF.request(components!,
                   method: .post,
                   encoding: URLEncoding.queryString,
                   interceptor: JwtRequestInterceptor(jwtStore: container))
        .validate()
        .responseData { response in
            switch response.response?.statusCode {
            case 200:
                completion(true)
            case 409:
                completion(false)
            default :
                print(response.response?.statusCode)
                print(phoneNumberItem)
            }
        }
    }
    
    func requestAuthNumberConfirmation(phoneNumber: String, authCode: String, completion: @escaping (Bool) -> Void) {
        let url = APIConstants.checkAuthCodeURL
        
        let phoneNumber = URLQueryItem(name: "phoneNumber", value: phoneNumber)
        let authCode = URLQueryItem(name: "authCode", value: authCode)
        
        var components = URLComponents(string: url)
        components?.queryItems = [phoneNumber, authCode]
        
        AF.request(components!,
                   method: .get,
                   encoding: URLEncoding.queryString)
        .responseData { response in
            switch response.response?.statusCode {
            case 200:
                completion(true)
            default:
                completion(false)
            }
        }
    }
}
