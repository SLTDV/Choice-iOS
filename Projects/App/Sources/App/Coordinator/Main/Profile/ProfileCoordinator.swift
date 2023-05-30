import Foundation

final class ProfileCoordinator: BaseCoordinator {
    override func start() {
        let vm = ProfileViewModel(coordinator: self)
        let vc = ProfileViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    override func navigate(to step: ChoiceStep) {
        switch step {
        case .logOutIsRequired:
            logOutIsRequired()
        case .detailPostIsRequired(let model):
            detailPostIsRequired(model: model)
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
    
    private func detailPostIsRequired(model: PostList) {
        let vc = DetailPostCoordiantor(navigationController: navigationController)
        vc.parentCoordinator = self
        childCoordinators.append(vc)
        vc.startDetailPostVC(model: model)
    }
}
