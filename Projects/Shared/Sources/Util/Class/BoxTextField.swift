import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

public final class BoxTextField: UITextField {
    private let disposeBag = DisposeBag()
    
    private let passwordShowButton = UIButton().then {
        $0.setImage(UIImage(systemName: "eye"), for: .normal)
        $0.tintColor = UIColor.quaternaryLabel
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delegate = self
        
        addSubview(passwordShowButton)
        passwordShowButtonDidTap()
        
        self.addLeftPadding()
        self.layer.borderColor = UIColor.quaternaryLabel.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        
        passwordShowButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(21)
            $0.height.equalTo(26)
            $0.width.equalTo(26)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func passwordShowButtonDidTap() {
        passwordShowButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.isSecureTextEntry.toggle()
                owner.passwordShowButton.isSelected.toggle()
                
                let buttonImage = owner.passwordShowButton.isSelected ? "eye.slash" : "eye"
                owner.passwordShowButton.setImage(UIImage(systemName: buttonImage), for: .normal)
            }.disposed(by: disposeBag)
    }
    
    public func hidePasswordShowButton() {
        passwordShowButton.isHidden = true
    }
}

extension BoxTextField: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.black.cgColor
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.quaternaryLabel.cgColor
    }
}
