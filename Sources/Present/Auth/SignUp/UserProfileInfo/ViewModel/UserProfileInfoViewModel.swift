import UIKit
import Alamofire

final class UserProfileInfoViewModel: BaseViewModel {
    let userInfo = SignUpModel.share
    
    func callToSignUpAPI(nickname: String, email: String, password: String, profileImgUrl: String?){
        let url = APIConstants.signUpURL
        let body : Parameters = [
            "email" : userInfo.email ?? "",
            "password" : userInfo.password ?? "",
            "nickname" : userInfo.nickname ?? "",
            "profileImgUrl" : userInfo.profileImgUrl ?? ""
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
