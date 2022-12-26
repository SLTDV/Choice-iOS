import Foundation

final class AddPostCoordiantor: BaseCoordinator {
    override func start() {
        let vm = AddPostViewModel(coordinator: self)
        let vc = AddPostViewController(viewModel: vm)
        
        self.navigationController.pushViewController(vc, animated: true)
    }
}
