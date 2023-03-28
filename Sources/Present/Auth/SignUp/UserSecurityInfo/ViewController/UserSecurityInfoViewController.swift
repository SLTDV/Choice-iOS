import UIKit
import RxSwift
import RxCocoa

final class UserSecurityInfoViewController: BaseVC<UserSecurityInfoViewModel> {
    private let disposeBag = DisposeBag()
    
    private lazy var restoreFrameYValue = 0.0
    
    private let emailLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private let inputEmailTextfield = UnderLineTextField().then {
        $0.setPlaceholder(placeholder: "이메일 입력")
    }
    
    private let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private let inputPasswordTextfield = UnderLineTextField().then {
        $0.setPlaceholder(placeholder: "8~16자리 영문, 숫자, 특수문자 조합")
        $0.textContentType = .newPassword
        $0.isSecureTextEntry = true
    }
    
    private let inputCheckPasswordTextfield = UnderLineTextField().then {
        $0.setPlaceholder(placeholder: "비밀번호 재입력")
        $0.textContentType = .newPassword
        $0.isSecureTextEntry = true
    }
    
    private lazy var signUpButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 8
    }
    
    private let warningLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.isHidden = true
        $0.textColor = .init(red: 1, green: 0.363, blue: 0.363, alpha: 1)
    }
    
    private func shakeAllTextField() {
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
    
    private func signUpButtonDidTap() {
        signUpButton.rx.tap
            .bind(onNext: {
                self.checkAvailabilitySignUp()
            }).disposed(by: disposeBag)
    }
    
    func testEmail(email: String) -> Bool {
        return viewModel.isValidEmail(email: email)
    }
    
    func testPassword(password: String) -> Bool {
        return viewModel.isValidPassword(password: password)
    }
    
    private func checkAvailabilitySignUp() {
        guard let email = inputEmailTextfield.text else { return }
        guard let password = inputPasswordTextfield.text else { return }
        guard let checkPassword = inputCheckPasswordTextfield.text else { return }
        
        if password.elementsEqual(checkPassword){
            if testEmail(email: email) && testPassword(password: password){
                print("성공")
            } else {
                shakeAllTextField()
                showWarningLabel(warning: "*이메일 또는 비밀번호 형식이 올바르지 않아요.")
            }
        } else {
            shakeAllTextField()
            showWarningLabel(warning: "*비밀번호가 일치하지 않아요.")
        }
    }
    
    override func configureVC() {
        restoreFrameYValue = self.view.frame.origin.y
        signUpButtonDidTap()
        
        navigationItem.title = "회원가입"
    }
    
    override func addView() {
        view.addSubviews(emailLabel,inputEmailTextfield, passwordLabel,
                         inputPasswordTextfield, inputCheckPasswordTextfield,  warningLabel, signUpButton)
    }
    
    override func setLayout() {
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(70)
            $0.leading.equalToSuperview().inset(26)
        }
        
        inputEmailTextfield.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(inputEmailTextfield.snp.bottom).offset(60)
            $0.leading.equalToSuperview().inset(26)
        }
        
        inputPasswordTextfield.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
        
        inputCheckPasswordTextfield.snp.makeConstraints {
            $0.top.equalTo(inputPasswordTextfield.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
        
        warningLabel.snp.makeConstraints {
            $0.leading.equalTo(signUpButton.snp.leading)
            $0.bottom.equalTo(signUpButton.snp.top).offset(-12)
        }
        
        signUpButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(64)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(49)
        }
    }
}
