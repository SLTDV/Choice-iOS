import UIKit

final class SignUpViewController: BaseVC<SignUpViewModel> {

    lazy var restoreFrameYValue = 0.0
    
    private let titleLabel = UILabel().then {
        $0.text = "Choice"
        $0.font = .systemFont(ofSize: 28, weight: .medium)
    }
     
    private let subTitleLabel = UILabel().then {
        $0.text = "선택의 고민을 한 번에"
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 16, weight: .light)
    }
    
    private let inputNicknameTextfield = UnderLineTextField().then {
        $0.setPlaceholder(placeholder: "닉네임")
    }
    
    private let inputEmailTextfield = UnderLineTextField().then {
        $0.setPlaceholder(placeholder: "이메일")
    }
    
    private let inputPasswordTextfield = UnderLineTextField().then {
        $0.setPlaceholder(placeholder: "비밀번호")
        $0.isSecureTextEntry = true
    }
    
    private let inputCheckPasswordTextfield = UnderLineTextField().then {
        $0.setPlaceholder(placeholder: "비밀번호확인")
        $0.isSecureTextEntry = true
    }
    
    private lazy var signUpButton = UIButton().then {
        $0.addTarget(self, action: #selector(pushSignUpButton), for: .touchUpInside)
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.backgroundColor = .init(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)
        $0.layer.cornerRadius = 8
    }
    
    private let warningLabel = UILabel().then {
        $0.isHidden = true
        $0.textColor = .init(red: 1, green: 0.363, blue: 0.363, alpha: 1)
        
    }
    
    @objc private func pushSignUpButton(_ sender: UIButton) {
        guard let nickname = inputNicknameTextfield.text else { return }
        guard let email = inputEmailTextfield.text else { return }
        guard let password = inputPasswordTextfield.text else { return }
        
        
        viewModel.login(nickname: nickname, email: email, password: password)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
    }
    
    override func configureVC() {
        restoreFrameYValue = self.view.frame.origin.y
    }
    
    override func addView() {
        view.addSubviews(titleLabel, subTitleLabel, inputNicknameTextfield, inputEmailTextfield,
                         inputPasswordTextfield, inputCheckPasswordTextfield, signUpButton)
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
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(inputCheckPasswordTextfield.snp.bottom).offset(48)
            $0.height.equalTo(49)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
    }
    
    override func bindVM() {
        
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
