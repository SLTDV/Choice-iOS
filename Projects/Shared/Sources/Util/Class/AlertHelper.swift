import UIKit

public protocol CustomAlertProtocol {
    typealias Action = () -> ()
    
    static var shared: CustomAlertProtocol { get }
    func showAlert(title: String,
                   message: String,
                   acceptButtonTitle: String?,
                   cancelButtonTitle: String,
                   cancelButtonAction: Action?,
                   acceptButtonAction: Action?,
                   vc viewController: UIViewController)
}

public class AlertHelper: CustomAlertProtocol {
    public static var shared: CustomAlertProtocol = AlertHelper()
    
    private init() {}
    
    private func addAction(to alertControl: UIAlertController, title: String, style: UIAlertAction.Style, handler: Action?) {
        let action = UIAlertAction(title: title, style: style) { _ in
            handler?()
        }
        alertControl.addAction(action)
    }
    
    public func showAlert(title: String,
                          message: String,
                          acceptButtonTitle: String?,
                          cancelButtonTitle: String,
                          cancelButtonAction: Action?,
                          acceptButtonAction: Action?,
                          vc viewController: UIViewController) {
        let alertControl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let actionTitle = acceptButtonTitle, let customAction = acceptButtonAction {
            addAction(to: alertControl, title: actionTitle, style: .destructive, handler: customAction)
        }
        
        if let cancelAction = cancelButtonAction {
            addAction(to: alertControl, title: cancelButtonTitle, style: .destructive, handler: cancelAction)
        } else {
            addAction(to: alertControl, title: cancelButtonTitle, style: .cancel, handler: nil)
        }
        
        DispatchQueue.main.async {
            viewController.present(alertControl, animated: true)
        }
    }
}
