import UIKit
import RxSwift
import RxCocoa
import Shared

final class RegistrationPasswordViewController: BaseVC<RegistrationPasswordViewModel> {
    private let disposeBag = DisposeBag()
    
    private let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    private let inputPasswordTextField = UITextField().then {
        $0.addLeftPadding()
        $0.placeholder = "8~16자리 영문, 숫자, 특수문자 조합"
        $0.layer.borderColor = ChoiceAsset.Colors.grayMedium.color.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.isSecureTextEntry = true
    }
    
    private let checkPasswordTextField = UITextField().then {
        $0.addLeftPadding()
        $0.placeholder = "비밀번호 재입력"
        $0.layer.borderColor = ChoiceAsset.Colors.grayMedium.color.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.isSecureTextEntry = true
    }
    
    private let passwordShowButton = UIButton().then {
        $0.setImage(UIImage(systemName: "eye"), for: .normal)
        $0.tintColor = ChoiceAsset.Colors.grayVoteButton.color
        $0.backgroundColor = .clear
    }
    
    private let checkPasswordShowButton = UIButton().then {
        $0.setImage(UIImage(systemName: "eye"), for: .normal)
        $0.tintColor = ChoiceAsset.Colors.grayVoteButton.color
        $0.backgroundColor = .clear
    }
    
    private lazy var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.isEnabled = false
        $0.backgroundColor = ChoiceAsset.Colors.grayVoteButton.color
        $0.layer.cornerRadius = 8
    }
    
    private let warningLabel = WarningLabel()
    
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
            owner.nextButton.backgroundColor = isValid ? .black : ChoiceAsset.Colors.grayVoteButton.color
        }.disposed(by: disposeBag)
    }
    
    private func checkPassword() {
        guard let password = inputPasswordTextField.text else { return }
        guard let checkPassword = checkPasswordTextField.text else { return }
        
        if password.elementsEqual(checkPassword) {
            if self.viewModel.isValidPassword(password: password){
                self.viewModel.pushUserProfileInfoVC(password: password)
            } else {
                self.warningLabel.show(warning: "*비밀번호 형식이 올바르지 않아요.")
            }
        } else {
            self.warningLabel.show(warning: "*비밀번호가 일치하지 않아요.")
        }
        
        LoadingIndicator.hideLoading()
    }
    
    private func passwordShowButtonDidTap() {
        passwordShowButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.inputPasswordTextField.isSecureTextEntry.toggle()
                owner.passwordShowButton.isSelected.toggle()
                
                let buttonImage = owner.passwordShowButton.isSelected ? "eye.slash" : "eye"
                owner.passwordShowButton.setImage(UIImage(systemName: buttonImage), for: .normal)
            }.disposed(by: disposeBag)
        
        checkPasswordShowButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.checkPasswordTextField.isSecureTextEntry.toggle()
                owner.checkPasswordShowButton.isSelected.toggle()
                
                let buttonImage = owner.checkPasswordShowButton.isSelected ? "eye.slash" : "eye"
                owner.checkPasswordShowButton.setImage(UIImage(systemName: buttonImage), for: .normal)
            }.disposed(by: disposeBag)
    }
    
    private func nextButtonDidTap() {
        nextButton.rx.tap
            .bind(onNext: {
                LoadingIndicator.showLoading(text: "")
                self.checkPassword()
            }).disposed(by: disposeBag)
    }
    
    override func configureVC() {
        bindUI()
        nextButtonDidTap()
        passwordShowButtonDidTap()
        
        navigationItem.title = "회원가입"
        
        inputPasswordTextField.delegate = self
        checkPasswordTextField.delegate = self
    }
    
    override func addView() {
        view.addSubviews(passwordLabel, inputPasswordTextField,
                         checkPasswordTextField, warningLabel, nextButton)
        
        inputPasswordTextField.addSubview(passwordShowButton)
        checkPasswordTextField.addSubview(checkPasswordShowButton)
    }
    
    override func setLayout() {
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(70)
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
        
        passwordShowButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(inputPasswordTextField.snp.trailing).inset(21)
            $0.height.equalTo(26)
            $0.width.equalTo(26)
        }
        
        checkPasswordShowButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(checkPasswordTextField.snp.trailing).inset(21)
            $0.height.equalTo(26)
            $0.width.equalTo(26)
        }
        
        warningLabel.snp.makeConstraints {
            $0.leading.equalTo(nextButton.snp.leading)
            $0.bottom.equalTo(nextButton.snp.top).offset(-12)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaInsets.bottom).inset(40)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(58)
        }
    }
}

extension RegistrationPasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.black.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = ChoiceAsset.Colors.grayMedium.color.cgColor
    }
}
