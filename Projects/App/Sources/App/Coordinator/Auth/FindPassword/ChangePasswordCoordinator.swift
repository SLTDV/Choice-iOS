import Foundation

class ChangePasswordCoordinator: BaseCoordinator {
    func startChangePasswordCoordinator(phoneNumber: String) {
        let vm = ChangePasswordViewModel(coordinator: self)
        let vc = ChangePasswordViewController(viewModel: vm, phoneNumber: phoneNumber)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    override func navigate(to step: ChoiceStep) {
        switch step {
        case .popToRoot:
            popToRoot()
        default:
            return
        }
    }
}

extension ChangePasswordCoordinator {
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
}
