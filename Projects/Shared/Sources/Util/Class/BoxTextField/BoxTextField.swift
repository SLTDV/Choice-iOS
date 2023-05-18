import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

public final class BoxTextField: UITextField {
    private let disposeBag = DisposeBag()
    
    public var type: TextFieldType = .normalTextField
    
    private let showPasswordButton = UIButton().then {
        $0.setImage(UIImage(systemName: "eye"), for: .normal)
        $0.tintColor = UIColor.quaternaryLabel
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delegate = self
        
        self.addLeftPadding()
        self.layer.borderColor = SharedAsset.Colors.grayMedium.color.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
    }
    
    public convenience init(type: TextFieldType) {
        self.init()
        self.type = type
        
        layoutTypeTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutTypeTextField() {
        switch type {
        case .normalTextField:
            break
        case .secureTextField:
            passwordShowButtonDidTap()
            self.rightView = showPasswordButton
            self.rightViewMode = .always
        }
    }
    
    private func passwordShowButtonDidTap() {
        showPasswordButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.isSecureTextEntry.toggle()
                owner.showPasswordButton.isSelected.toggle()
                
                let buttonImage = owner.showPasswordButton.isSelected ? "eye.slash" : "eye"
                owner.showPasswordButton.setImage(UIImage(systemName: buttonImage), for: .normal)
            }.disposed(by: disposeBag)
    }
    
    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var padding = super.rightViewRect(forBounds: bounds)
        padding.origin.x -= 20
        
        return padding
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        let padding = super.textRect(forBounds: bounds)
        let rightViewWidth: CGFloat = rightView?.bounds.width ?? 0
        let spacing: CGFloat = 10
        
        let newPadding = CGRect(x: padding.origin.x, y: padding.origin.y, width: padding.width - rightViewWidth - spacing, height: padding.height)
        
        return newPadding
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}

extension BoxTextField: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.black.cgColor
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = SharedAsset.Colors.grayMedium.color.cgColor
    }
}
