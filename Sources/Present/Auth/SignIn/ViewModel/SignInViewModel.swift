import Foundation
import Alamofire
import RxSwift

final class SignInViewModel: BaseViewModel {
    func pushMainVC() {
        coordinator.navigate(to: .mainVCIsRequried)
    }
    
    func pushSignUpVC() {
        coordinator.navigate(to: .signUpIsRequired)
    }
    
    func callToSignInAPI(email: String, password: String, completion: @escaping (Bool) -> Void) {
        let url = APIConstants.signInURL
        let params = [
            "email" : email,
            "password" : password
        ] as Dictionary
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default)
        .validate()
        .responseData(emptyResponseCodes: [200, 201, 204]) { [weak self] response in
            switch response.response?.statusCode {
            case 200:
                let decodeResult = try? JSONDecoder().decode(ManageTokenModel.self, from: response.data ?? .init())
                KeyChain.shared.create(key: "accessToken",
                                       token: decodeResult?.accessToken ?? "")
                KeyChain.shared.create(key: "refreshToken",
                                       token: decodeResult?.refreshToken ?? "")
                KeyChain.shared.create(key: "accessExpiredTime",
                                       token: decodeResult?.accessExpiredTime ?? "")
                KeyChain.shared.create(key: "refreshExpiredTime",
                                       token: decodeResult?.refreshExpiredTime ?? "")
                self?.pushMainVC()
                LoadingIndicator.hideLoading()
                completion(true)
            case 400:
                LoadingIndicator.hideLoading()
                completion(false)
            default:
                LoadingIndicator.hideLoading()
                completion(false)
            }
        }
    }
}
