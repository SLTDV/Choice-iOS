import Foundation

final class UserProfileInfoCoordinator: BaseCoordinator {
    func startUserProfileInfoVC(model: SignUpModel) {
        let vm = UserProfileInfoViewModel(coordinator: self)
        let vc = UserProfileInfoViewController(viewModel: vm, model: model)
        
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
