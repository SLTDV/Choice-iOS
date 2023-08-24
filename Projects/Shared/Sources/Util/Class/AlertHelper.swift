import UIKit

public protocol CustomAlertProtocol {
    typealias Action = () -> ()
    
    static var shared: CustomAlertProtocol { get }
    func showAlert(title: String,
                   message: String,
                   actionTitle: String?,
                   cancelTitle: String?,
                   cancelAction: Action?,
                   customAction: Action?,
                   vc viewController: UIViewController)
}

public class AlertHelper: CustomAlertProtocol {
    public static var shared: CustomAlertProtocol = AlertHelper()
    
    private init() {}
    
    public func showAlert(title: String,
                          message: String,
                          actionTitle: String?,
                          cancelTitle: String?,
                          cancelAction: Action?,
                          customAction: Action?,
                          vc viewController: UIViewController) {
        let alertControl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let actionTitle = actionTitle, let customAction = customAction {
            let eventAction = UIAlertAction(title: actionTitle, style: .destructive) { _ in
                customAction()
            }
            alertControl.addAction(eventAction)
        }
        
        if let cancelTitle = cancelTitle {
            if let cancelAction = cancelAction {
                let eventAction = UIAlertAction(title: cancelTitle, style: .destructive) { _ in
                    cancelAction()
                }
                alertControl.addAction(eventAction)
            } else {
                let eventAction = UIAlertAction(title: cancelTitle, style: .cancel)
                alertControl.addAction(eventAction)
            }
        }
        
        DispatchQueue.main.async {
            viewController.present(alertControl, animated: true)
        }
    }
}
