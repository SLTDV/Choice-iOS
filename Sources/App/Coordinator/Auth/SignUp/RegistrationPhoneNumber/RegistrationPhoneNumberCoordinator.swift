import Foundation

final class RegistrationPhoneNumberCoordinator: BaseCoordinator {
    func startRegistrationPasswordVC(phoneNumber: String) {
        let vm = RegistrationPhoneNumberViewModel(coordinator: self)
        let vc = RegistrationPhoneNumberViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    override func navigate(to step: ChoiceStep) {
        switch step {
        case .registrationPasswordIsRequired(let phoneNumber):
            registrationPasswordIsRequired(phoneNumber: phoneNumber)
        default:
            return
        }
    }
}

extension RegistrationPhoneNumberCoordinator {
    private func registrationPasswordIsRequired(phoneNumber: String) {
        let vc = RegistrationPasswordCoordinator(navigationController: navigationController)
        vc.parentCoordinator = self
        childCoordinators.append(vc)
        vc.startRegistrationPasswordVC(phoneNumber: phoneNumber)
    }
}
