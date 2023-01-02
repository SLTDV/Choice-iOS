import Foundation
import Alamofire
import RxSwift

protocol SignInErrorProtocol: AnyObject {
    var statusCodeData: PublishSubject<Int> { get set }
}

final class SignInViewModel: BaseViewModel {
    weak var delegate: SignInErrorProtocol?
    
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
            print("success = \(response.response?.statusCode)")
            switch response.result {
            case .success(let data):
                let tk = KeyChain()
                let decodeResult = try? JSONDecoder().decode(SignInModel.self, from: data)
                tk.create(key: "accessToken", token: decodeResult?.accessToken ?? "")
                tk.create(key: "refreshToken", token: decodeResult?.refreshToken ?? "")
                self?.pushMainVC()
            case .failure:
                self?.delegate?.statusCodeData.onNext(response.response?.statusCode ?? 0)
            }
        }
    }
}
