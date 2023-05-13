import Foundation

final class DetailPostCoordiantor: BaseCoordinator {
    func startDetailPostVC(model: PostList) {
        let vm = DetailPostViewModel(coordinator: self)
        let vc = DetailPostViewController(viewModel: vm, model: model)
        
        navigationController.pushViewController(vc, animated: true)
    }
}
