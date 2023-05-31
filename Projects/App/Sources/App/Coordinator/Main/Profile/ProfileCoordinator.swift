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
        case .detailPostIsRequired(let model, let type):
            detailPostIsRequired(model: model, type: type)
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
    
    private func detailPostIsRequired(model: PostList, type: ViewControllerType) {
        let vc = DetailPostCoordiantor(navigationController: navigationController)
        vc.parentCoordinator = self
        childCoordinators.append(vc)
        vc.startDetailPostVC(model: model, type: type)
    }
}
