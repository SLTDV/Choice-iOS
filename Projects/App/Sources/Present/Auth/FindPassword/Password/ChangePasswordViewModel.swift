import Foundation
import Alamofire
import JwtStore

enum ErrorType: Error {
    case recentPassword
    case incorrectForm
}

class ChangePasswordViewModel: BaseViewModel {
    func requestToChangePassword(phoneNumber: String, password: String, completion: @escaping (Result<Void, ErrorType>) -> Void = { _ in }) {
        let url = APIConstants.findPasswordAuthCodeURL
        AF.request(url,
                   method: .patch,
                   encoding: JSONEncoding.default)
        .validate()
        .responseData { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                print("Error - change password = \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            switch response.response?.statusCode {
            case 200:
                completion(.success(()))
                case 
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
