import UIKit
import Alamofire
import JwtStore
import Swinject

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinator: [Coordinator] = []
    var parentCoordinator: Coordinator?
    let window: UIWindow?
    private let container = AppDelegate.container.resolve(JwtStore.self)!
    
    init(navigationCotroller: UINavigationController, window: UIWindow?) {
        self.window = window
        self.navigationController = navigationCotroller
        window?.makeKeyAndVisible()
    }
    
    func start() {
        let url = APIConstants.reissueURL
        let headers: HTTPHeaders = ["RefreshToken" : container.getToken(type: .refreshToken)]
        
        let signInController = SignInCoordinator(navigationController: navigationController)
        let homeController = HomeCoordinator(navigationController: navigationController)
        let whiteControlelr = WhiteViewCoordinator(navigationController: navigationController)
        window?.rootViewController = navigationController
        start(coordinator: whiteControlelr)
        
        AF.request(url,
                   method: .patch,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .validate()
        .responseDecodable(of: ManageTokenModel.self) { [weak self] response in
            self?.navigationController.popViewController(animated: false)
            switch response.result {
            case .success(let data):
                self?.container.saveToken(type: .refreshToken, token: data.refreshToken)
                self?.start(coordinator: homeController)
            case .failure:
                self?.start(coordinator: signInController)
            }
        }
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
