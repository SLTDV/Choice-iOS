import Foundation

final class UserProfileInfoCoordinator: BaseCoordinator {
    override func start() {
        let vm = UserProfileInfoViewModel(coordinator: self)
        let vc = UserProfileInfoViewController(viewModel: vm)
        
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

extension UserProfileInfoCoordinator {
    private func popVCIsRequired() {
        navigationController.popToRootViewController(animated: true)
    }
}
