import Foundation

class ChangePasswordCoordinator: BaseCoordinator {
    override func start() {
        let vm = ChangePasswordViewModel(coordinator: self)
        let vc = ChangePasswordViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
}
