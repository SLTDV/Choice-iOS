import Foundation

class PhoneNumberAuthCoordiantor: BaseCoordinator {
    override func start() {
        let vm = PhoneNumberAuthViewModel(coordinator: self)
        let vc = PhoneNumberAuthViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
}
