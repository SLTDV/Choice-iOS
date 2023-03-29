import Foundation

final class UserSecurityInfoCoordinator: BaseCoordinator {
    override func start() {
        let vm = UserSecurityInfoViewModel(coordinator: self)
        let vc = UserSecurityInfoViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    override func navigate(to step: ChoiceStep) {
        switch step {
        case .userProfileInfoIsRequired(let model):
            userProfileInfoIsRequired(model: model)
        default:
            return
        }
    }
}

extension UserSecurityInfoCoordinator {
    private func userProfileInfoIsRequired(model: SignUpModel) {
        let vc = UserProfileInfoCoordinator(navigationController: navigationController)
        vc.parentCoordinator = self
        childCoordinators.append(vc)
        vc.startUserProfileInfoVC(model: model)
    }
}
