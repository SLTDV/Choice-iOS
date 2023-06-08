import Foundation
import Alamofire
import JwtStore

class ChangePasswordViewModel: BaseViewModel {
    func requestToChangePassword(phoneNumber: String, password: String, completion: @escaping (Result<Void, Error>) -> Void = { _ in }) {
        let url = APIConstants.findPasswordAuthCodeURL
        AF.request(url,
                   method: .patch,
                   encoding: JSONEncoding.default)
        .validate()
        .responseData { response in
            switch response.result {
            case .success:
                print("asf")
                completion(.success(()))
            case .failure(let error):
                print("Error - change password = \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func isValidPassword(password: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,16}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    func popToRoot() {
        
    }
}
