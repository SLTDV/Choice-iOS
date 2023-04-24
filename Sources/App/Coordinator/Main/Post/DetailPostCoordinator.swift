import Foundation

final class DetailPostCoordiantor: BaseCoordinator {
    func startDetailPostVC(model: Posts) {
        let vm = DetailPostViewModel(coordinator: self)
        let vc = DetailPostViewController(viewModel: vm, model: model)
        
        navigationController.pushViewController(vc, animated: true)
    }
}
