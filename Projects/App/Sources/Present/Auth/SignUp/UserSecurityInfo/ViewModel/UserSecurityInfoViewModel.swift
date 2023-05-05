import Foundation
import Alamofire
import Shared
import JwtStore

final class UserSecurityInfoViewModel: BaseViewModel {
    var email = ""
    var password = ""
    
    func checkDuplicateEmail(email: String, completion: @escaping (Bool) -> Void){
        let url = APIConstants.emailDuplicationURL
        let body : Parameters = [
            "email": email
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: body,
                   encoding: JSONEncoding.default).responseData { response in
            switch response.response?.statusCode {
            case 200:
                LoadingIndicator.hideLoading()
                completion(true)
            case 409:
                LoadingIndicator.hideLoading()
                completion(false)
            default:
                print(response.response?.statusCode ?? 0)
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
    
    func pushUserProfileInfoVC() {
        coordinator.navigate(to: .userProfileInfoIsRequired(email: email, password: password))
    }
}