import Foundation

class SignIUpCoordinator: BaseCoordinator {
    override func start() {
        let vm = SignUpViewModel(coordinator: self)
        let vc = SignUpViewController(viewModel: vm)
        
        navigationController.setViewControllers([vc], animated: true)
    }
}
