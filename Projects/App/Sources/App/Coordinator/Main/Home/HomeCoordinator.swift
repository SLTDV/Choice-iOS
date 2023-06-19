import Foundation

class HomeCoordinator: BaseCoordinator {
    override func start() {
        let vm = HomeViewModel(coordinator: self)
        let vc = HomeViewController(viewModel: vm)
        
        navigationController.setViewControllers([vc], animated: false)
    }
    
    override func navigate(to step: ChoiceStep) {
        switch step {
        case .addPostIsRequired:
            addPostIsRequired()
        case .detailPostIsRequired(let model, let type):
            detailPostIsRequired(model: model, type: type)
        case .profileIsRequired:
            profileIsRequired()
        default:
            return
        }
    }
}

extension HomeCoordinator {
    private func addPostIsRequired() {
        let vc = AddContentsCoordiantor(navigationController: navigationController)
        vc.parentCoordinator = self
        childCoordinators.append(vc)
        vc.start()
    }
    
    private func detailPostIsRequired(model: PostList, type: ViewControllerType) {
        let vc = DetailPostCoordiantor(navigationController: navigationController)
        vc.parentCoordinator = self
        childCoordinators.append(vc)
        let vm = HomeViewModel(coordinator: self)
        let hVc = HomeViewController(viewModel: vm)
        vc.startDetailPostVC(model: model, type: type, vc: hVc)
    }
    
    private func profileIsRequired() {
        let vc = ProfileCoordinator(navigationController: navigationController)
        vc.parentCoordinator = self
        childCoordinators.append(vc)
        vc.start()
    }
}
