import Foundation
import Alamofire

final class UserSecurityInfoViewModel: BaseViewModel {
    func callToSignUpAPI(nickname: String, email: String, password: String, profileImgUrl: String?){
        let url = APIConstants.signUpURL
        let body : Parameters = [
            "email" : email,
            "password" : password,
            "nickname" : nickname,
            "profileImgUrl" : profileImgUrl ?? ""
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: body,
                   encoding: JSONEncoding.default).responseData { response in
            switch response.response?.statusCode {
            case 201:
                self.coordinator.navigate(to: .popVCIsRequired)
            default:
                print(response.response?.statusCode ?? 0)
                return 
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
    
    func buttonDidTap() {
        coordinator.navigate(to: .userProfileInfoIsRequired)
    }
}
