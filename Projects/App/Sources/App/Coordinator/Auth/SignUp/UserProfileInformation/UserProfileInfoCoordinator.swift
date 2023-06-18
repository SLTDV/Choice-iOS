import Foundation
import Shared

final class UserProfileInfoCoordinator: BaseCoordinator {
    override func start() {
            let phoneNumber = "100"
            let password = "100"

            let vm = UserProfileInfoViewModel(coordinator: self)
            let vc = UserProfileInfoViewController(viewModel: vm, phoneNumber: phoneNumber, password: password)

            navigationController.pushViewController(vc, animated: true)
    }
    
    func startUserProfileInfoVC(phoneNumber: String, password: String) {
        let vm = UserProfileInfoViewModel(coordinator: self)
        let vc = UserProfileInfoViewController(viewModel: vm, phoneNumber: phoneNumber, password: password)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    override func navigate(to step: ChoiceStep) {
        switch step {
        case .pushCompleteViewIsRequired:
            pushCompleteViewIsRequired()
        default:
            return
        }
    }
}

extension UserProfileInfoCoordinator {
    private func pushCompleteViewIsRequired() {
        navigationController.pushViewController(CompleteViewController(), animated: true)
    }
}
