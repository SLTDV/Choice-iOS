import Foundation

final class UserProfileInformationCoordinator: BaseCoordinator {
    override func start() {
        let vm = UserProfileInformationViewModel(coordinator: self)
        let vc = UserProfileViewController(viewModel: vm)
        
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

extension UserProfileInformationCoordinator {
    private func popVCIsRequired() {
        navigationController.popViewController(animated: true)
    }
}
