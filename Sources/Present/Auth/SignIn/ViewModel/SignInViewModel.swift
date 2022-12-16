import Foundation

class SignInViewModel: BaseViewModel {
    func pushSignUpVC() {
        coordinator.navigate(to: .signUpIsRequired)
    }
}
