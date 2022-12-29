import Foundation
import Alamofire

final class SignUpViewModel: BaseViewModel {
    func callToSignUpAPI(nickname: String, email: String, password: String){
        let url = APIConstants.signUpURL
        
        let header : HTTPHeaders = ["Content-Type" : "application/json"]
        
        let body : Parameters = [
            "email" : email,
            "password" : password,
            "nickname" : nickname
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: body,
                   encoding: JSONEncoding.default,
                   headers: header).responseData { response in
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
        let passwordRegEx = "^.*(?=^.{8,15}$)(?=.*\\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
}
