import Foundation
import Alamofire
import RxSwift

final class SignInViewModel: BaseViewModel {
    let keyChainService = KeyChainService(keychain: KeyChain.shared)
    func pushMainVC() {
        coordinator.navigate(to: .mainVCIsRequried)
    }
    
    func pushSignUpVC() {
        coordinator.navigate(to: .signUpIsRequired)
    }
    
    func requestSignIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
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
        .responseDecodable(of: ManageTokenModel.self) { [weak self] response in
            switch response.result {
            case .success(let data):
                self?.keyChainService.saveToken(type: .accessToken,
                                                token: data.accessToken)
                self?.keyChainService.saveToken(type: .refreshToken,
                                                token: data.refreshToken)
                self?.keyChainService.saveToken(type: .accessExpriedTime,
                                                token: data.accessExpiredTime)
                self?.keyChainService.saveToken(type: .refreshExpriedTime,
                                                token: data.refreshExpiredTime)
                self?.pushMainVC()
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
