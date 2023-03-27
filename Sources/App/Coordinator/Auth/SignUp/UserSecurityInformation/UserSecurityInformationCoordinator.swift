import Foundation

final class UserSecurityInformationCoordinator: BaseCoordinator {
    override func start() {
        let vm = UserSecurityInformationViewModel(coordinator: self)
        let vc = UserSecurityViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    override func navigate(to step: ChoiceStep) {
        switch step {
        case .userProfileInformationIsRequired:
            userInformationIsRequired()
        default:
            return
        }
    }
}

extension UserSecurityInformationCoordinator {
    private func userInformationIsRequired() {
        let vc = UserProfileInformationCoordinator(navigationController: navigationController)
        vc.parentCoordinator = self
        childCoordinators.append(vc)
        vc.start()
    }
}
