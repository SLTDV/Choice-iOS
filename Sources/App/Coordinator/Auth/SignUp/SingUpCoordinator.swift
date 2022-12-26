import Foundation

final class SignUpCoordinator: BaseCoordinator {
    override func start() {
        let vm = SignUpViewModel(coordinator: self)
        let vc = SignUpViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    override func navigate(to step: ChoiceStep) {
        switch step {
        case .popVC:
            popVC()
        default:
            return
        }
    }
}

extension SignUpCoordinator {
    private func popVC() {
        self.navigationController.popViewController(animated: true)
    }
}
