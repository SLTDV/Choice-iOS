import UIKit
import Alamofire

final class UserProfileInfoViewModel: BaseViewModel {
    func callToSignUp(email: String, password: String, nickname: String, profileImage: UIImage?, completion: @escaping (Bool) -> Void) {
        var url = ""
        var headers: HTTPHeaders?
        
        if let profileImage = profileImage {
            AF.upload(multipartFormData: { multipartFormData in
                if let image = profileImage.pngData() {
                    multipartFormData.append(image, withName: "profileImage", fileName: "\(image).png", mimeType: "image/png")
                }
                url = APIConstants.profileImageUploadURL
                headers = ["Content-Type" : "multipart/form-data"]
            }, to: url, method: .post, headers: headers, interceptor: JwtRequestInterceptor())
            .validate().responseData(emptyResponseCodes: [200, 201, 204]) { response in
                switch response.result {
                case .success(let data):
                    let decodeResponse = try? JSONDecoder().decode(SignUpModel.self, from: data)
                    let profileImageUrl = decodeResponse?.profileImageUrl

                    headers = ["Content-Type": "application/json"]
                    url = APIConstants.signUpURL
                    let body : Parameters = [
                        "email" : email,
                        "password" : password,
                        "nickname" : nickname,
                        "profileImgUrl" : profileImageUrl
                    ]
                    
                    AF.request(url,
                               method: .post,
                               parameters: body,
                               encoding: JSONEncoding.default).responseData { response in
                        switch response.response?.statusCode {
                        case 201:
                            completion(true)
                        default:
                            completion(false)
                        }
                    }
                case .failure(let error):
                    print("profileImage upload error \(String(describing: error.localizedDescription))")
                }
            }
        } else {
            url = APIConstants.signUpURL
            let body : Parameters = [
                "email" : email,
                "password" : password,
                "nickname" : nickname,
                "profileImgUrl" : profileImage
            ]
            
            AF.request(url,
                       method: .post,
                       parameters: body,
                       encoding: JSONEncoding.default).responseData { response in
                switch response.response?.statusCode {
                case 201:
                    LoadingIndicator.hideLoading()
                    completion(true)
                case 409:
                    LoadingIndicator.hideLoading()
                    completion(false)
                default:
                    completion(false)
                }
            }
        }
    }
    
    func navigateRootVC() {
        self.coordinator.navigate(to: .popVCIsRequired)
    }
}
