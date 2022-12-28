import Foundation

final class DetailPostCoordiantor: BaseCoordinator {
    override func start() {
        let vm = DetailPostViewModel(coordinator: self)
        let vc = DetailPostViewController(viewModel: vm)
        
        self.navigationController.pushViewController(vc, animated: true)
    }
}
