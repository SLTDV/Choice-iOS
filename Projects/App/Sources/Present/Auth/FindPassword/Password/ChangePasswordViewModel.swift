import Foundation
import Alamofire
import JwtStore

final class ChangePasswordViewModel: BaseViewModel {
    var phoneNumber: String
    
    init(coordinator: BaseCoordinator, phoneNumber: String) {
        self.phoneNumber = phoneNumber
        
        super.init(coordinator: coordinator)
    }
    
    func requestToChangePassword(password: String, completion: @escaping (Result<Void, Error>) -> Void = { _ in }) {
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
    
    func popToRootVC() {
        coordinator.navigate(to: .popVCIsRequired)
    }
}
