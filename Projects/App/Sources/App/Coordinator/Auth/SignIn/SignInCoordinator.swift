import Foundation

final class SignInCoordinator: BaseCoordinator {
    override func start() {
        let vm = SignInViewModel(coordinator: self)
        let vc = SignInViewController(viewModel: vm)
        
        navigationController.setViewControllers([vc], animated: false)
    }
    
    override func navigate(to step: ChoiceStep) {
        switch step {
        case .signUpIsRequired:
            signUpIsRequired()
        case .mainVCIsRequried:
            mainVCIsRequired()
        default:
            return
        }
    }
}

extension SignInCoordinator {
    private func signUpIsRequired() {
        let vc = RegistrationPhoneNumberCoordinator(navigationController: navigationController)
        vc.parentCoordinator = self
        childCoordinators.append(vc)
        vc.start()
    }
    
    private func mainVCIsRequired() {
        let vc = HomeCoordinator(navigationController: navigationController)
        vc.parentCoordinator = self
        childCoordinators.append(vc)
        vc.start()
    }
}
