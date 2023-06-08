import Foundation
import Alamofire
import JwtStore

class ChangePasswordViewModel: BaseViewModel {
    func requestToChangePassword(phoneNumber: String, password: String, completion: @escaping (Result<Void, Error>) -> Void = { _ in }) {
        let url = APIConstants.changePasswordURL
        
        print(phoneNumber, password)
        let param = [
            "phoneNumber" : phoneNumber,
            "password" : password
        ]
        
        AF.request(url,
                   method: .patch,
                   parameters: param,
                   encoding: JSONEncoding.default)
        .validate()
        .responseData { response in
            switch response.result {
            case .success:
                print("Success")
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
        coordinator.navigate(to: .popToRoot)
    }
}
