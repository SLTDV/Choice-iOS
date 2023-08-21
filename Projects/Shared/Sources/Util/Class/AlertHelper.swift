import UIKit

protocol CustomAlertProtocl {
    typealias Action = () -> ()
    
    static var shared: CustomAlertProtocl { get }
    func showAlert(title: String, message: String, actionTitle: String, onConfirm: @escaping Action, vc viewController: UIViewController)
}

class AlertHelper: CustomAlertProtocl {
    static var shared: CustomAlertProtocl = AlertHelper()
    var alertControl = UIAlertController(title: "", message: "", preferredStyle: .alert)
    
    private init() {}
    
    func showAlert(title: String, message: String, actionTitle: String, onConfirm: @escaping Action, vc viewController: UIViewController) {
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
