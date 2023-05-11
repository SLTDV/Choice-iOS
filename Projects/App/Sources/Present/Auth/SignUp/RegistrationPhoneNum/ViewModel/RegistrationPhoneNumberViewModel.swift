import Foundation
import Alamofire
import JwtStore

final class RegistrationPhoneNumberViewModel: BaseViewModel {
    func requestAuthNumber(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        let url = APIConstants.certificationRequestURL
        
        let phoneNumberItem = URLQueryItem(name: "phoneNumber", value: phoneNumber)
        
        var components = URLComponents(string: url)
        components?.queryItems = [phoneNumberItem]
        
        AF.request(components!,
                   method: .post,
                   encoding: URLEncoding.queryString)
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
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,16}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    func pushRegistrationPasswordVC(phoneNumber: String) {
        coordinator.navigate(to: .registrationPasswordIsRequired(phoneNumber: phoneNumber))
    }
}
