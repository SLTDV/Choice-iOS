import Foundation
import Alamofire

final class SignUpViewModel: BaseViewModel {
    
    func login(nickname: String, email: String, password: String){
        let url = "http://10.82.17.76:8090/auth/signup"
        
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
                   headers: header).responseData{ response in
            
            let decodeData = try? JSONDecoder().decode(SignUpModel.self, from: response.data!)
            print(decodeData ?? "")
            print(response.response?.statusCode)
            
            switch response.response!.statusCode {
            case (200..<300):
                print("success")
            case 400:
                print("error1")
            case 409:
                print("이미 유저가 존재하는 이메일입니다.")
            case 500:
                print("500")
            default:
                print("error")
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
