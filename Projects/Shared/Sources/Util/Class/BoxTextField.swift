import UIKit
import SnapKit

public final class BoxTextField: UITextField {
    
    private lazy var underLineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addLeftPadding()
        self.layer.borderColor = UIColor.quaternaryLabel.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
