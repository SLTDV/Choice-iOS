import Foundation
import Alamofire
import RxSwift
import Shared
import JwtStore
import Swinject

final class SignInViewModel: BaseViewModel {
    let container = AppDelegate.container.resolve(JwtStore.self)!
    func pushMainVC() {
        coordinator.navigate(to: .mainVCIsRequried)
    }
    
    func pushSignUpVC() {
        coordinator.navigate(to: .signUpIsRequired)
    }
    
    func requestSignIn(phoneNumber: String, password: String, completion: @escaping (Bool) -> Void) {
        let url = APIConstants.signInURL
        let params = [
            "phoneNumber" : phoneNumber,
            "password" : password
        ] as Dictionary
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default)
        .validate()
        .responseDecodable(of: ManageTokenModel.self) { [weak self] response in
            switch response.result {
            case .success(let data):
                self?.container.setToken(data: data)
                self?.pushMainVC()
                print("accessTokenExpiredTime = \(self?.container.getToken(type: .accessExpriedTime))")
                LoadingIndicator.hideLoading()
                completion(true)
            case .failure(let error):
                print("signIn Error = \(error.localizedDescription)")
                LoadingIndicator.hideLoading()
                completion(false)
            }
        }
    }
}
