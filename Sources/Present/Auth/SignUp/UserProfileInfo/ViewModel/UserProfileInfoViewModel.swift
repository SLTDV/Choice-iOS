import UIKit

final class UserProfileInfoViewModel: BaseViewModel {
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
}
