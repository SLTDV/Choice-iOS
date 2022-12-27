import Foundation
import Alamofire

final class SignInViewModel: BaseViewModel {
    func pushMainVC() {
        coordinator.navigate(to: .mainVCIsRequried)
    }
    
    func pushSignUpVC() {
        coordinator.navigate(to: .signUpIsRequired)
    }
    
    func callToSignInAPI(email: String, password: String) {
        let url = APIConstants.signInURL
        let headers : HTTPHeaders = ["Content-Type" : "application/json"]
        let params = [
            "email" : email,
            "password" : password
        ] as Dictionary
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: headers
        )
        .validate()
        .responseData(emptyResponseCodes: [200, 201, 204]) { [weak self] response in
            switch response.result {
            case .success(let data):
                let tk = KeyChain()
                
                if let accessToken = (try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])? ["accessToken"] as? String {
                    tk.create(key: "accessToken", token: accessToken)
                }
                
                if let refreshToken = (try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])? ["refreshToken"] as? String {
                    tk.create(key: "refreshToken", token: refreshToken)
                }
                self?.pushMainVC()
            case .failure(let error):
                print("error = \(error.errorDescription)")
            }
        }
    }
}
