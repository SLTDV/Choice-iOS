import UIKit

final class WarningLabel: UILabel {
    func show(warning: String) {
        DispatchQueue.main.async {
            self.isHidden = false
            self.text = warning
        }
    }
}
