import UIKit
import RxSwift
import RxCocoa

final class RegistrationPhoneNumberViewController: BaseVC<RegistrationPhoneNumberViewModel> {
    private let disposeBag = DisposeBag()
    
    private lazy var restoreFrameYValue = 0.0
    
    private let emailLabel = UILabel().then {
        $0.text = "전화번호"
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    private let inputPhoneNumberTextfield = UITextField().then {
        $0.addLeftPadding()
        $0.placeholder = "전화번호 입력"
        $0.layer.borderColor = ChoiceAsset.Colors.grayMedium.color.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.keyboardType = .numberPad
    }
    
    private let CertificationRequestButton = UIButton().then {
        $0.setTitle("인증 요청", for: .normal)
        $0.isEnabled = false
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.backgroundColor = ChoiceAsset.Colors.grayVoteButton.color
        $0.layer.cornerRadius = 8
    }
    
    private let CertificationNumberTextfield = UITextField().then {
        $0.isHidden = true
        $0.addLeftPadding()
        $0.placeholder = "인증번호 입력"
        $0.layer.borderColor = ChoiceAsset.Colors.grayMedium.color.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.keyboardType = .numberPad
    }
    
    private lazy var signUpButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.isEnabled = false
        $0.backgroundColor = ChoiceAsset.Colors.grayVoteButton.color
        $0.layer.cornerRadius = 8
    }
    
    private let warningLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.isHidden = true
        $0.textColor = .init(red: 1, green: 0.363, blue: 0.363, alpha: 1)
    }
    
    private func showWarningLabel(warning: String) {
        DispatchQueue.main.async {
            self.warningLabel.isHidden = false
            self.warningLabel.text = warning
        }
    }
    
    private func signUpButtonDidTap() {
        CertificationNumberTextfield.rx.text.orEmpty
            .map { $0.count == 4 }
            .bind(with: self) { owner, isValid in
                owner.signUpButton.backgroundColor = isValid ? .black : ChoiceAsset.Colors.grayVoteButton.color
                owner.signUpButton.isEnabled = isValid
            }.disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.checkAuthCode()
            }.disposed(by: disposeBag)
    }
    
    private func checkAuthCode() {
        guard let phoneNumber = inputPhoneNumberTextfield.text else { return }
        guard let authCode = CertificationNumberTextfield.text else { return }
        
        self.viewModel.requestCheckAuthCode(inputphoneNumber: phoneNumber, authCode: authCode)
    }
    
    private func bindUI() {
        inputPhoneNumberTextfield.rx.text.orEmpty
            .map { $0.count == 11 }
            .bind(with: self) { owner, isValid in
                owner.CertificationRequestButton.backgroundColor = isValid ? .black : ChoiceAsset.Colors.grayVoteButton.color
                owner.CertificationRequestButton.isEnabled = isValid
            }.disposed(by: disposeBag)
    }
  
    private func CertificationRequestButtonDidTap() {
        let phoneNumberObservable = inputPhoneNumberTextfield.rx.text.orEmpty
        
        CertificationRequestButton.rx.tap
            .withLatestFrom(phoneNumberObservable)
            .take(1)
            .bind(with: self) { owner, inputPhoneNumber in
                owner.viewModel.requestCertification(inputPhoneNumber: inputPhoneNumber)
                owner.CertificationNumberTextfield.isHidden = false
            }.disposed(by: disposeBag)
    }
    
    func testEmail(email: String) -> Bool {
        return viewModel.isValidEmail(email: email)
    }
    
    func testPassword(password: String) -> Bool {
        return viewModel.isValidPassword(password: password)
    }
    
    override func configureVC() {
        restoreFrameYValue = self.view.frame.origin.y
        signUpButtonDidTap()
        CertificationRequestButtonDidTap()
        
        bindUI()
        
        inputPhoneNumberTextfield.delegate = self
        CertificationNumberTextfield.delegate = self
        
        navigationItem.title = "회원가입"
    }
    
    override func addView() {
        view.addSubviews(emailLabel,inputPhoneNumberTextfield, CertificationRequestButton,
                         CertificationNumberTextfield, warningLabel, signUpButton)
    }
    
    override func setLayout() {
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(70)
            $0.leading.equalToSuperview().inset(26)
        }
        
        inputPhoneNumberTextfield.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(25)
            $0.leading.equalToSuperview().inset(26)
            $0.trailing.equalTo(CertificationRequestButton.snp.leading).offset(-10)
            $0.height.equalTo(51)
        }
        
        CertificationRequestButton.snp.makeConstraints {
            $0.top.equalTo(inputPhoneNumberTextfield.snp.top)
            $0.trailing.equalToSuperview().inset(26)
            $0.width.equalTo(inputPhoneNumberTextfield.snp.width).multipliedBy(0.4)
            $0.height.equalTo(51)
        }
        
        CertificationNumberTextfield.snp.makeConstraints {
            $0.top.equalTo(inputPhoneNumberTextfield.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(51)
        }
        
        warningLabel.snp.makeConstraints {
            $0.leading.equalTo(signUpButton.snp.leading)
            $0.bottom.equalTo(signUpButton.snp.top).offset(-12)
        }
        
        signUpButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaInsets.bottom).inset(40)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(49)
        }
    }
}

extension RegistrationPhoneNumberViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.black.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = ChoiceAsset.Colors.grayMedium.color.cgColor
    }
}
