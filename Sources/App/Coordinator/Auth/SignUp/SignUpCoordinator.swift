import Foundation

final class SignUpCoordinator: BaseCoordinator {
    override func start() {
        let vm = SignUpViewModel(coordinator: self)
        let vc = UserSecurityViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    override func navigate(to step: ChoiceStep) {
        switch step {
        case .popVCIsRequired:
            popVCIsRequired()
        case .userInformationIsRequired:
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
        vc.parentCoordinator = self
        childCoordinators.append(vc)
        vc.start()
    }
}
