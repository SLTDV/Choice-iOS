import Foundation

final class AddImageCoordiantor: BaseCoordinator {
    func startAddImageVC(title: String, content: String) {
        let vm = AddImageViewModel(coordinator: self, title: title, content: content)
        let vc = AddImageViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    override func navigate(to step: ChoiceStep) {
        switch step {
        case .popAddpostIsRequired:
            popVCIsRequired()
        default:
            return
        }
    }
}

extension AddImageCoordiantor {
    private func popVCIsRequired() {
        navigationController.popToRootViewController(animated: true)
    }
}

