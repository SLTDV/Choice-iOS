import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: BaseVC<SignUpViewModel>{
    private let disposeBag = DisposeBag()
    
    private lazy var restoreFrameYValue = 0.0
    
    private let titleLabel = UILabel().then {
        $0.text = "Choice"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 28, weight: .medium)
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "선택의 고민을 한 번에"
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 16, weight: .light)
    }
    
    private let inputNicknameTextfield = UnderLineTextField().then {
        $0.setPlaceholder(placeholder: "닉네임을 입력해주세요")
    }
    
    private let inputEmailTextfield = UnderLineTextField().then {
        $0.setPlaceholder(placeholder: "이메일을 입력해주세요")
    }
    
    private let inputPasswordTextfield = UnderLineTextField().then {
        $0.setPlaceholder(placeholder: "비밀번호(8~16자리 영문, 숫자, 특수문자 조합)")
        $0.textContentType = .newPassword
        $0.isSecureTextEntry = true
    }
    
    private let inputCheckPasswordTextfield = UnderLineTextField().then {
        $0.setPlaceholder(placeholder: "비밀번호를 한번 더 입력해주세요")
        $0.textContentType = .newPassword
        $0.isSecureTextEntry = true
    }
    
    private lazy var signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 8
    }
    
    private let warningLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.isHidden = true
        $0.textColor = .init(red: 1, green: 0.363, blue: 0.363, alpha: 1)
    }
    
    private func shakeAllTextField() {
        inputNicknameTextfield.shake()
        inputEmailTextfield.shake()
        inputPasswordTextfield.shake()
        inputCheckPasswordTextfield.shake()
    }
    
    private func showWarningLabel(warning: String) {
        DispatchQueue.main.async {
            self.warningLabel.isHidden = false
            self.warningLabel.text = warning
        }
    }
    
    private func pushSignUpButton() {
        guard let nickname = inputNicknameTextfield.text else { return }
        guard let email = inputEmailTextfield.text else { return }
        guard let password = inputPasswordTextfield.text else { return }
        guard let checkPassword = inputCheckPasswordTextfield.text else { return }
        
        if password.elementsEqual(checkPassword){
            if testEmail(email: email) && testPassword(password: password){
                viewModel.login(nickname: nickname, email: email, password: password)
            }else {
                shakeAllTextField()
                showWarningLabel(warning: "*이메일 또는 비밀번호 형식이 올바르지 않아요.")
            }
        }else {
            shakeAllTextField()
            showWarningLabel(warning: "*비밀번호가 일치하지 않아요.")
        }
    }
    
    private func signUpButtonDidTap() {
        signUpButton.rx.tap
            .bind(onNext: {
                self.pushSignUpButton()
            }).disposed(by: disposeBag)
    }
    
    func testEmail(email: String) -> Bool {
        return viewModel.isValidEmail(email: email)
    }
    
    func testPassword(password: String) -> Bool {
        return viewModel.isValidPassword(password: password)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
    }
    
    override func configureVC() {
        restoreFrameYValue = self.view.frame.origin.y
        signUpButtonDidTap()
    }
    
    override func addView() {
        view.addSubviews(titleLabel, subTitleLabel, inputNicknameTextfield, inputEmailTextfield,
                         inputPasswordTextfield, inputCheckPasswordTextfield,  warningLabel, signUpButton)
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(101)
            $0.leading.equalToSuperview().inset(25)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(9)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        inputNicknameTextfield.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(77)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
        
        inputEmailTextfield.snp.makeConstraints {
            $0.top.equalTo(inputNicknameTextfield.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
        
        inputPasswordTextfield.snp.makeConstraints {
            $0.top.equalTo(inputEmailTextfield.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
        
        inputCheckPasswordTextfield.snp.makeConstraints {
            $0.top.equalTo(inputPasswordTextfield.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
        
        warningLabel.snp.makeConstraints {
            $0.leading.equalTo(signUpButton.snp.leading)
            $0.top.equalTo(signUpButton.snp.bottom).offset(10)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(inputCheckPasswordTextfield.snp.bottom).offset(48)
            $0.height.equalTo(49)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
    }
}

extension SignUpViewController {
    
    @objc private func showKeyboard(_ notification: Notification) {
        if self.view.frame.origin.y == restoreFrameYValue {
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                self.view.frame.origin.y -= keyboardHeight - 240
            }
        }
    }
    
    @objc private func hideKeyboard(_ notification: Notification) {
        if self.view.frame.origin.y != restoreFrameYValue {
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                self.view.frame.origin.y += keyboardHeight - 240
            }
        }
    }
    
    private func addKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.showKeyboard(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}
