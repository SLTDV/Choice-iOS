import Foundation
import Alamofire
import RxSwift

final class SignUpViewModel: BaseViewModel {
    
    func login(nickname: String, email: String, password: String){
        let url = "http://10.82.17.76:8090/auth/signup"
        
        let header : HTTPHeaders = ["Content-Type" : "application/json"]
        
        let body : Parameters = [
            "email" : email,
            "password" : password,
            "nickname" : nickname
        ]
        
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData{ response in
            switch response.response?.statusCode {
            case 201:
                print("success")
            case 400:
                print("error1")
            case 409:
                print("이미 유저가 존재합니다.")
            case 500:
                print("500")
            default:
                print("error")
            }
        }
    }
}
