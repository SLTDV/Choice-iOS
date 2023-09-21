import UIKit
import RxSwift
import RxCocoa
import DesignSystem

protocol InputPasswordComponentProtocol: AnyObject {
    func nextButtonDidTap(password: String)
}

final class InputPasswordComponent: UIView {
    weak var delegate: InputPasswordComponentProtocol?
    
    private let disposeBag = DisposeBag()
    
    let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    let inputPasswordTextField = BoxTextField(type: .secureTextField).then {
        $0.placeholder = "8~16자리 영문, 숫자, 특수문자 조합"
        $0.isSecureTextEntry = true
    }
    
    let checkPasswordTextField = BoxTextField(type: .secureTextField).then {
        $0.placeholder = "비밀번호 재입력"
        $0.isSecureTextEntry = true
    }
    
    let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.isEnabled = false
        $0.backgroundColor = DesignSystemAsset.Colors.grayVoteButton.color
        $0.layer.cornerRadius = 8
    }
    
    let warningLabel = WarningLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addView()
        setLayout()
        bindRx()
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addView() {
        self.addSubviews(passwordLabel, inputPasswordTextField,
                         checkPasswordTextField, warningLabel, nextButton)
    }
    
    func setLayout() {
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(70)
            $0.leading.equalToSuperview().inset(26)
        }
        
        inputPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(58)
        }
        
        checkPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(inputPasswordTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(58)
        }
        
        warningLabel.snp.makeConstraints {
            $0.leading.equalTo(nextButton.snp.leading)
            $0.bottom.equalTo(nextButton.snp.top).offset(-12)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaInsets.bottom).inset(40)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(58)
        }
    }
    
    private func bindUI() {
        let passwordObservable = inputPasswordTextField.rx.text.orEmpty
        let checkPasswordObservable = checkPasswordTextField.rx.text.orEmpty
        
        Observable.combineLatest(
            passwordObservable,
            checkPasswordObservable,
            resultSelector: { s1, s2 in (8...16).contains(s1.count) && (8...16).contains(s2.count) }
        )
        .bind(with: self) { owner, isValid in
            owner.nextButton.isEnabled = isValid
            owner.nextButton.backgroundColor = isValid ? .black : DesignSystemAsset.Colors.grayVoteButton.color
        }.disposed(by: disposeBag)
    }
    
    private func bindRx() {
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.delegate?.nextButtonDidTap(password: owner.inputPasswordTextField.text!)
            }.disposed(by: disposeBag)
    }
}
