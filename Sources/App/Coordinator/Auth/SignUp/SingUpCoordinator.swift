import Foundation

final class SignUpCoordinator: BaseCoordinator {
    override func start() {
        let vm = SignUpViewModel(coordinator: self)
        let vc = SignUpViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    override func navigate(to step: ChoiceStep) {
        switch step {
        case .popVCIsRequired:
            popVCIsRequired()
        default:
            return
        }
    }
}

extension SignUpCoordinator {
    private func popVCIsRequired() {
        self.navigationController.popViewController(animated: true)
    }
}
