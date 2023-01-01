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
        let tk = KeyChain()
        let url = APIConstants.reissueURL
        let headers: HTTPHeaders = ["RefreshToken" : tk.read(key: "refreshToken") ?? .init()]
        
        let signInController = SignInCoordinator(navigationController: navigationController)
        let MainController = MainCoordinator(navigationController: navigationController)
        
        window?.rootViewController = navigationController
        
        AF.request(url, method: .patch, encoding: JSONEncoding.default, headers: headers).validate().responseData { [weak self] response in
            print("retry status code = \(response.response?.statusCode)")
            switch response.result {
            case .success(let tokenData):
                print("success")
                if let refreshToken = (try? JSONSerialization.jsonObject(with: tokenData, options: []) as? [String: Any])? ["refreshToken"] as? String {
                    tk.create(key: "refreshToken", token: refreshToken)
                }
                self?.start(coordinator: MainController)
            case .failure:
                print("falure")
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
