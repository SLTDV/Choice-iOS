import Foundation

final class DetailPostCoordiantor: BaseCoordinator {
    func startDetailPostVC(model: PostList, type: ViewControllerType) {
        let vm = DetailPostViewModel(coordinator: self)
        let vc = DetailPostViewController(viewModel: vm, model: model, type: type)
        
        navigationController.pushViewController(vc, animated: true)
    }
}
