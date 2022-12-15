import UIKit

extension UIView {
    func addSubviews(_ subView: UIView...) {
        subView.forEach(addSubview(_:))
    }
}
