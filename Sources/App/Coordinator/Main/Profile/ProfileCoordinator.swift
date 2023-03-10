import Foundation

final class ProfileCoordinator: BaseCoordinator {
    override func start() {
        let vm = ProfileViewModel(coordinator: self)
        let vc = ProfileViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    override func navigate(to step: ChoiceStep) {
        switch step {
        case .logoutIsRequired:
            logOutIsRequired()
        default:
            return
        }
    }
}

extension ProfileCoordinator {
    private func logOutIsRequired() {
        let vc = SignInCoordinator(navigationController: navigationController)
        vc.parentCoordinator = self
        childCoordinators.append(vc)
        vc.start()
    }
}
