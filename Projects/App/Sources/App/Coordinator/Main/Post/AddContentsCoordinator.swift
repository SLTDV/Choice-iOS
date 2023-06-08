import Foundation

final class AddContentsCoordiantor: BaseCoordinator {
    override func start() {
        let vm = AddContentsViewModel(coordinator: self)
        let vc = AddContentsViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    override func navigate(to step: ChoiceStep) {
        switch step {
        case .addImageIsRequired(let title, let content):
            addImageIsRequired(title: title, content: content)
        default:
            return
        }
    }
}

extension AddContentsCoordiantor {
    private func addImageIsRequired(title: String, content: String?) {
        let vc = AddImageCoordiantor(navigationController: navigationController)
        vc.parentCoordinator = self
        childCoordinators.append(vc)
        vc.startAddImageVC(title: title, content: content ?? "")
    }
}
