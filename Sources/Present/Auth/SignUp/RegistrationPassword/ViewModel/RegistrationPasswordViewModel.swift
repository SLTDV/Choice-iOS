import UIKit

final class RegistrationPasswordViewModel: BaseViewModel {
    var phoneNumber = ""
    
    init(coordinator: RegistrationPasswordCoordinator, phoneNumber: String) {
        super.init(coordinator: coordinator)
        self.phoneNumber = phoneNumber
    }
    
    func isValidPassword(password: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,16}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    func pushUserProfileInfoVC(password: String) {
        coordinator.navigate(to: .userProfileInfoIsRequired(phoneNumber: phoneNumber, password: password))
    }
}
