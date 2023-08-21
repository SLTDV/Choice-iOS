import UIKit

public protocol CustomAlertProtocol {
    typealias Action = () -> ()
    
    static var shared: CustomAlertProtocol { get }
    static func showAlert(title: String, message: String, actionTitle: String, onConfirm: @escaping Action, vc viewController: UIViewController)
}

public class AlertHelper: CustomAlertProtocol {
    public static var shared: CustomAlertProtocol = AlertHelper()
    
    private init() {}
    
    public static func showAlert(title: String, message: String, actionTitle: String, onConfirm: @escaping Action, vc viewController: UIViewController) {
        let alertControl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let eventAction = UIAlertAction(title: actionTitle, style: .destructive) { _ in
            onConfirm()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alertControl.addAction(eventAction)
        alertControl.addAction(cancelAction)
        
        viewController.present(alertControl, animated: true)
    }
}
