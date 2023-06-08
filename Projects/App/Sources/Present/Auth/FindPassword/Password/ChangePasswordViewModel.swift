import Foundation
import Alamofire
import JwtStore

 enum ErrorType: Error {
    case recentPassword, incorrectForm, serverError
}

class ChangePasswordViewModel: BaseViewModel {
    func requestToChangePassword(phoneNumber: String, password: String, completion: @escaping (Result<Void, ErrorType>) -> Void = { _ in }) {
        let url = APIConstants.findPasswordAuthCodeURL
        AF.request(url,
                   method: .patch,
                   encoding: JSONEncoding.default)
        .validate()
        .responseData { response in
            switch response.response?.statusCode {
            case 200:
                completion(.success(()))
            case 400:
                completion(.failure(.incorrectForm))
            case 401:
                completion(.failure(.recentPassword))
            default:
                completion(.failure(.serverError))
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
