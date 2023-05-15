import Foundation

final class UserProfileInfoCoordinator: BaseCoordinator {
    func startUserProfileInfoVC(phoneNumber: String, password: String) {
        let vm = UserProfileInfoViewModel(coordinator: self)
        let vc = UserProfileInfoViewController(viewModel: vm, phoneNumber: phoneNumber, password: password)
        
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
