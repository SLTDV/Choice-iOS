import UIKit

extension UIView {
    func addSubviews(subView: UIView...) {
        subView.forEach(addSubview(_:))
    }
}
