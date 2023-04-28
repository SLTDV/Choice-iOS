import Foundation

final class RegistrationPasswordCoordinator: BaseCoordinator {
    func startRegistrationPasswordVC(phoneNumber: String) {
        let vm = RegistrationPasswordViewModel(coordinator: self, phoneNumber: phoneNumber)
        let vc = RegistrationPasswordViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    override func navigate(to step: ChoiceStep) {
        switch step {
        case .userProfileInfoIsRequired(let phoneNumber, let password):
            userProfileInfoIsRequired(phoneNumber: phoneNumber, password: password)
        default:
            return
        }
    }
}

extension RegistrationPasswordCoordinator {
    private func userProfileInfoIsRequired(phoneNumber: String, password: String) {
        let vc = UserProfileInfoCoordinator(navigationController: navigationController)
        vc.parentCoordinator = self
        childCoordinators.append(vc)
        vc.startUserProfileInfoVC(phoneNumber: phoneNumber, password: password)
    }
}
