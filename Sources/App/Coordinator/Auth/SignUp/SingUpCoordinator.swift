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
        case .UserInformationIsRequired:
            userInformationIsRequired()
        default:
            return
        }
    }
}

extension SignUpCoordinator {
    private func popVCIsRequired() {
        navigationController.popViewController(animated: true)
    }
    
    private func userInformationIsRequired() {
        let vc = UserInformationCoordinator(navigationController: navigationController)
        self.parentCoordinator = self
        childCoordinators.append(vc)
        vc.start()
    }
}
