import Foundation

final class DetailPostCoordiantor: BaseCoordinator {
    func startDetailPostVC(model: PostModel) {
        let vm = DetailPostViewModel(coordinator: self)
        let vc = DetailPostViewController(viewModel: vm, model: model)
        
        self.navigationController.pushViewController(vc, animated: true)
    }
}
