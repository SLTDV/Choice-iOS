import UIKit
import Alamofire

final class UserProfileInfoViewModel: BaseViewModel {
    func callToSignUp(email: String, password: String, nickname: String, profileImage: UIImage) {
        var url = APIConstants.profileImageUploadURL
        var headers: HTTPHeaders = ["Content-Type" : "multipart/form-data"]
        
        AF.upload(multipartFormData: { multipartFormData in
            if let image = profileImage.pngData() {
                multipartFormData.append(image, withName: "profileImage", fileName: "\(image).png", mimeType: "image/png")
            }
        }, to: url, method: .post, headers: headers, interceptor: JwtRequestInterceptor())
        .validate().responseData(emptyResponseCodes: [200, 201, 204]) { response in
            switch response.result {
            case .success(let data):
                let decodeResponse = try? JSONDecoder().decode(SignUpModel.self, from: data)
                let profileImageUrl = decodeResponse?.profileImageUrl ?? ""
        
                headers = ["Content-Type": "application/json"]
                url = APIConstants.signUpURL
                let body : Parameters = [
                    "email" : email,
                    "password" : password,
                    "nickname" : nickname,
                    "profileImgUrl" : profileImageUrl
                ]
                print("profileImage = \(profileImageUrl)")
                
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
            case .failure(let error):
                print("upload error \(String(describing: error.localizedDescription))")
            }
        }
    }
}
