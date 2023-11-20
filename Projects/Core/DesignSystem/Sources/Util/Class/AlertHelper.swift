import UIKit

public protocol CustomAlertProtocol {
    typealias Action = () -> ()
    
    static var shared: CustomAlertProtocol { get }
    func showAlert(
        title: String,
        message: String,
        acceptTitle: String?,
        acceptAction: Action?,
        cancelTitle: String,
        cancelAction: Action?,
        vc viewController: UIViewController
    )
}

public class AlertHelper: CustomAlertProtocol {
    public static let shared: CustomAlertProtocol = AlertHelper()
    
    private init() {}
    
    private func addAction(
        to alertControl: UIAlertController,
        title: String,
        style: UIAlertAction.Style,
        handler: Action?
    ) {
        let action = UIAlertAction(title: title, style: style) { _ in
            handler?()
        }
        alertControl.addAction(action)
    }
    
    public func showAlert(
        title: String,
        message: String,
        acceptTitle: String? = "",
        acceptAction: Action? = nil,
        cancelTitle: String,
        cancelAction: Action? = nil,
        vc viewController: UIViewController
    ) {
        let alertControl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let actionTitle = acceptTitle, let acceptAction = acceptAction {
            addAction(to: alertControl, title: actionTitle, style: .destructive, handler: acceptAction)
        }
        
        if let cancelAction = cancelAction {
            addAction(to: alertControl, title: cancelTitle, style: .destructive, handler: cancelAction)
        } else {
            addAction(to: alertControl, title: cancelTitle, style: .cancel, handler: nil)
        }
        
        DispatchQueue.main.async {
            viewController.present(alertControl, animated: true)
        }
    }
}
