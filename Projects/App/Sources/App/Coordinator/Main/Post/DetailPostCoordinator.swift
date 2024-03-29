import Foundation

final class DetailPostCoordiantor: BaseCoordinator {
    func startDetailPostVC(model: PostList, type: ViewControllerType) {
        let vm = DetailPostViewModel(coordinator: self)
        let vc = DetailPostViewController(viewModel: vm, model: model, type: type)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    override func navigate(to step: ChoiceStep) {
        switch step {
        case .popVCIsRequired:
            popVCIsRequired()
        default:
            return
        }
    }
}

extension DetailPostCoordiantor {
    func popVCIsRequired() {
        navigationController.popToRootViewController(animated: true)
    }
}
