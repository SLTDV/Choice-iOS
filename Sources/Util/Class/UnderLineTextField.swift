import UIKit
import SnapKit

final class UnderLineTextField: UITextField {
    
    private lazy var underLineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(underLineView)
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(self.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPlaceholder(placeholder: String) {
        self.font = .systemFont(ofSize: 14)
        self.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 2.0, height: 0.0))
        self.leftViewMode = .always
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        underLineView.backgroundColor = .gray
    }
}
