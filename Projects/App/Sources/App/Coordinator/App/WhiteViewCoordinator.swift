import UIKit

class WhiteViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .white
    }
}

class WhiteViewCoordinator: BaseCoordinator {
    override func start() {
        let vc = WhiteViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}
