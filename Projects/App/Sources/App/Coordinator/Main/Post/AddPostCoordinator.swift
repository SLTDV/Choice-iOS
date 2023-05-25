import Foundation

final class AddPostCoordiantor: BaseCoordinator {
    override func start() {
        let vm = AddPostViewModel(coordinator: self)
        let vc = AddPostViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    override func navigate(to step: ChoiceStep) {
        switch step {
        case .popAddpostIsRequired:
            popAddpostIsRequired()
        default:
            return
        }
    }
}

extension AddPostCoordiantor {
    private func popAddpostIsRequired() {
        navigationController.popViewController(animated: true)
    }
}
