import Foundation

class ChangePasswordCoordinator: BaseCoordinator {
    func startChangePasswordCoordinator(phoneNumber: String) {
        let vm = ChangePasswordViewModel(coordinator: self, phoneNumber: phoneNumber)
        let vc = ChangePasswordViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    override func navigate(to step: ChoiceStep) {
        switch step {
        case .popToRootVC:
            popToRootVC()
        default:
            return
        }
    }
}

extension ChangePasswordCoordinator {
    func popToRootVC() {
        navigationController.popToRootViewController(animated: true)
    }
}
