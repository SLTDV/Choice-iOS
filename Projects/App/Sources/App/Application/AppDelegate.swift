import UIKit
import Swinject
import JwtStore
import Shared
import RxSwift
import NetworksMonitor
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let container = Container()
    var assembler: Assembler!
    let disposeBag = DisposeBag()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        
        assembler = Assembler([
            JwtStoreAssembly()
        ], container: AppDelegate.container)
        
        let monitor = NetworksStatus.shared
        monitor.startMonitoring()
        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let deviceToken: String = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("DeviceToken is = \(deviceToken)")
        UserDefaults.standard.set(deviceToken, forKey: "deviceToken")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed Register Noti = \(error.localizedDescription)")
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
        let monitor = NetworksStatus.shared
        monitor.stopMonitoring()
    }
    
    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}
