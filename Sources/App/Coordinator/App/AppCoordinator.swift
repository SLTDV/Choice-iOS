import UIKit
import Alamofire

final class AppCoordinator: Coordinator {
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
        let tk = KeyChain.shared
        let tkService = KeyChainService(keychain: tk)
        let url = APIConstants.reissueURL
        let headers: HTTPHeaders = ["RefreshToken" : tkService.getToken(type: .refreshToken)]
        
        let signInController = SignInCoordinator(navigationController: navigationController)
        let homeController = HomeCoordinator(navigationController: navigationController)
        
        window?.rootViewController = navigationController
        
        AF.request(url, method: .patch, encoding: JSONEncoding.default, headers: headers).validate().responseData { [weak self] response in
            switch response.result {
            case .success(let data):
                let decodeResult = try? JSONDecoder().decode(ManageTokenModel.self, from: data)
                tkService.saveToken(type: .refreshToken, token: decodeResult?.refreshToken ?? "")
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
