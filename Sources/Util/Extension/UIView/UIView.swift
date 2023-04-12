import UIKit

extension UIView {
    func addSubviews(_ subView: UIView...) {
        subView.forEach(addSubview(_:))
    }
    
    func startAnimation(button: UIButton) {
        let scale = CGAffineTransform(scaleX: 1.2, y: 1.2)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.2) {
                button.transform = scale
            } completion: { finished in
                UIView.animate(withDuration: 0.2) {
                    button.transform = .identity
                }
            }
        }
    }
}
