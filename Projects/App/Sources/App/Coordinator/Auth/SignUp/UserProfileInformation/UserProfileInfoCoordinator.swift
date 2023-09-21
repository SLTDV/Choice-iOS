import Foundation
import DesignSystem

final class UserProfileInfoCoordinator: BaseCoordinator {
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
