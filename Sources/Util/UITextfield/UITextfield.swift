import UIKit

extension UITextField { // textField 흔들기
    func shake() {
        UIView.animate(withDuration: 0.6, animations: {

            for _ in self.subviews {
                self.subviews[0].backgroundColor = .red
            }
        })
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")

        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-10.0, 10.0, -10.0, 10.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
