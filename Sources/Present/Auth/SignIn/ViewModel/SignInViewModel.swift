import Foundation

final class SignInViewModel: BaseViewModel {
    func pushSignUpVC() {
        coordinator.navigate(to: .signUpIsRequired)
    }
}
