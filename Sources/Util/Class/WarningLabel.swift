import UIKit

final class WarningLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = .systemFont(ofSize: 14, weight: .semibold)
        self.isHidden = true
        self.textColor = .init(red: 1, green: 0.363, blue: 0.363, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(warning: String) {
        DispatchQueue.main.async {
            self.isHidden = false
            self.text = warning
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.isHidden = true
        }
    }
}
