import Foundation

class PhoneNumberAuthCoordiantor: BaseCoordinator {
    override func start() {
        let vm = PhoneNumberAuthViewModel(coordinator: self)
        let vc = PhoneNumberAuthViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    override func navigate(to step: ChoiceStep) {
        switch step {
        case .findPasword_changepassword(let phoneNumber):
            findPasword_changepassword(phoneNumber: phoneNumber)
        default:
            return
        }
    }
}

extension PhoneNumberAuthCoordiantor {
    private func findPasword_changepassword(phoneNumber: String) {
        let vc = ChangePasswordCoordinator(navigationController: navigationController)
        vc.startChangePasswordCoordinator(phoneNumber: phoneNumber)
    }
}
