import Foundation

final class UserInformationCoordinator: BaseCoordinator {
    override func start() {
        let vm = UserInformationViewModel(coordinator: self)
        let vc = UserInformationViewController(viewModel: vm)
        
        navigationController.setViewControllers([vc], animated: true)
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

extension UserInformationCoordinator {
    private func popVCIsRequired() {
        navigationController.popViewController(animated: true)
    }
}
