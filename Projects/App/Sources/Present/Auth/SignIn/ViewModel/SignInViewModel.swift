import Foundation
import Alamofire
import RxSwift
import JwtStore
import Swinject

final class SignInViewModel: BaseViewModel {
    let container = DIContainer.shared.resolve(JwtStore.self)!
    
    func requestSignIn(model: RequestSignInModel) -> Observable<Void> {
        return Observable.create { (observer) -> Disposable in
            AF.request(
                SignInTarget.requestSignIn(
                    RequestSignInModel(
                        phoneNumber: model.phoneNumber,
                        password: model.password,
                        fcmToken: model.fcmToken
                    )
                )
            )
            .validate()
            .responseDecodable(of: ManageTokenModel.self) { [weak self] response in
                switch response.result {
                case .success(let data):
                    self?.container.setToken(data: data)
                    self?.pushMainVC()
                    observer.onNext(())
                case .failure(let error):
                    print("signIn Error = \(error.localizedDescription)")
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func pushMainVC() {
        coordinator.navigate(to: .mainVCIsRequried)
    }
    
    func pushSignUpVC() {
        coordinator.navigate(to: .signUpIsRequired)
    }
    
    func pushFindPassword() {
        coordinator.navigate(to: .findPassword_phoneNumberAuth)
    }
    
}
