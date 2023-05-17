import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

public final class BoxTextField: UITextField {
    private let disposeBag = DisposeBag()
    
    private let showPasswordButton = UIButton().then {
        $0.setImage(UIImage(systemName: "eye"), for: .normal)
        $0.tintColor = UIColor.quaternaryLabel
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delegate = self
        
        addSubview(showPasswordButton)
        passwordShowButtonDidTap()
        
        self.addLeftPadding()
        self.layer.borderColor = UIColor.quaternaryLabel.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        
        showPasswordButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(21)
            $0.size.equalTo(26)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func passwordShowButtonDidTap() {
        showPasswordButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.isSecureTextEntry.toggle()
                owner.showPasswordButton.isSelected.toggle()
                
                let buttonImage = owner.showPasswordButton.isSelected ? "eye.slash" : "eye"
                owner.showPasswordButton.setImage(UIImage(systemName: buttonImage), for: .normal)
            }.disposed(by: disposeBag)
    }
    
    public func hidePasswordShowButton() {
        showPasswordButton.isHidden = true
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
