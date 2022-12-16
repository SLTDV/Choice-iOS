import UIKit

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinator: [Coordinator] = []
    var parentCoordinator: Coordinator?
    let window: UIWindow?
    
    init(navigationCotroller: UINavigationController, window: UIWindow?) {
        self.window = window
        self.navigationController = navigationCotroller
        window?.makeKeyAndVisible()
    }
    
    func start() {
        let signUpController = SignIUpCoordinator(navigationController: navigationController)
        window?.rootViewController = navigationController
        
        start(coordinator: signUpController)
    }
    
    func start(coordinator: Coordinator) {
        coordinator.start()
    }
    
    func didFinish(coordinator: Coordinator) {
        
    }
    
    func navigate(to step: ChoiceStep) {
        
    }
    
    func removeChildCoordinators() {
        
    }
}
