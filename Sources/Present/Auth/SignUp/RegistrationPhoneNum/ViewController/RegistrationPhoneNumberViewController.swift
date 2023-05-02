import UIKit
import RxSwift
import RxCocoa

final class RegistrationPhoneNumberViewController: BaseVC<RegistrationPhoneNumberViewModel> {
    private let disposeBag = DisposeBag()
    
    private var isValidCertification = true
    
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
    
    private let certificationRequestButton = UIButton().then {
        $0.setTitle("인증 요청", for: .normal)
        $0.isEnabled = false
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.backgroundColor = ChoiceAsset.Colors.grayVoteButton.color
        $0.layer.cornerRadius = 8
    }
    
    private let certificationNumberTextfield = UITextField().then {
        $0.addLeftPadding()
        $0.placeholder = "인증번호 입력"
        $0.layer.borderColor = ChoiceAsset.Colors.grayMedium.color.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.keyboardType = .numberPad
        $0.isHidden = true
    }
    
    private let countLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .black
    }
    
    private let resendLabel = UILabel().then {
        $0.text = "인증번호가 오지 않나요?"
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .gray
        $0.isHidden = true
    }
    
    private let resendButton = UIButton().then {
        $0.setTitle("재요청", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        $0.setTitleColor(.black, for: .normal)
        $0.isHidden = true
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
        signUpButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.checkAuthCode()
            }.disposed(by: disposeBag)
    }
    
    private func checkAuthCode() {
        guard let phoneNumber = inputPhoneNumberTextfield.text else { return }
        guard let authCode = certificationNumberTextfield.text else { return }
        
        self.viewModel.requestCheckAuthCode(inputphoneNumber: phoneNumber, authCode: authCode) { isVaild in
            if isVaild {
                self.viewModel.pushRegistrationPasswordVC(phoneNumber: phoneNumber)
            } else {
                self.showWarningLabel(warning: "*인증번호가 일치하지 않습니다")
            }
        }
    }
    
    private func bindUI() {
        certificationNumberTextfield.rx.text.orEmpty
            .map { $0.count == 4 }
            .bind(with: self) { owner, isValid in
                owner.signUpButton.backgroundColor = isValid ? .black : ChoiceAsset.Colors.grayVoteButton.color
                owner.signUpButton.isEnabled = isValid
            }.disposed(by: disposeBag)
        
        inputPhoneNumberTextfield.rx.text.orEmpty
            .map { $0.count == 11 }
            .bind(with: self) { owner, isValid in
                owner.certificationRequestButton.backgroundColor = isValid ? .black : ChoiceAsset.Colors.grayVoteButton.color
                owner.certificationRequestButton.isEnabled = isValid
            }.disposed(by: disposeBag)
    }
  
    private func certificationRequestButtonDidTap() {
        let phoneNumberObservable = inputPhoneNumberTextfield.rx.text.orEmpty
        
        certificationRequestButton.rx.tap
            .withLatestFrom(phoneNumberObservable)
            .bind(with: self) { owner, inputPhoneNumber in
                    owner.viewModel.requestCertification(inputPhoneNumber: inputPhoneNumber) { inVaild in
                        if inVaild {
                            owner.setupPossibleBackgroundTimer()
                            
                            owner.certificationNumberTextfield.isHidden = false
                            owner.resendLabel.isHidden = false
                            owner.resendButton.isHidden = false
                            
                            owner.certificationRequestButton.backgroundColor = ChoiceAsset.Colors.grayVoteButton.color
                            owner.certificationRequestButton.isEnabled = false
                            
                            self.showWarningLabel(warning: "")
                        } else {
                            self.showWarningLabel(warning: "*이미 인증된 전화번호입니다")
                        }
                    }
            }.disposed(by: disposeBag)
    }
    
    private func resendButtonDidTap() {
        let phoneNumberObservable = inputPhoneNumberTextfield.rx.text.orEmpty
        
        resendButton.rx.tap
            .withLatestFrom(phoneNumberObservable)
            .bind(with: self) { owner, inputPhoneNumber in
                if owner.isValidCertification {
                    owner.viewModel.requestCertification(inputPhoneNumber: inputPhoneNumber) { inVaild in
                        if inVaild {
                            owner.certificationRequestButton.backgroundColor = ChoiceAsset.Colors.grayVoteButton.color
                            owner.setupPossibleBackgroundTimer()
                            owner.certificationNumberTextfield.isHidden = false
                            
                            self.showWarningLabel(warning: "")
                        } else {
                            self.showWarningLabel(warning: "*이미 인증된 전화번호입니다")
                        }
                    }
                } else {
                    owner.showWarningLabel(warning: "*3분 후에 다시 시도해주세요")
                }
            }.disposed(by: disposeBag)
    }
    
    private func setupPossibleBackgroundTimer() {
        let count = 180
        
        isValidCertification = false
        
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .take(count)
            .map { count - $0 }
            .bind(with: self) { owner, remainingSeconds in
                let minutes = remainingSeconds / 60
                let seconds = remainingSeconds % 60
                owner.countLabel.text = String(format: "%02d:%02d", minutes, seconds)
                
                if remainingSeconds == 0 {
                    owner.countLabel.text = "00:00"
                    owner.isValidCertification = true
                }
            }.disposed(by: disposeBag)
    }
    
    private func testPassword(password: String) -> Bool {
        return viewModel.isValidPassword(password: password)
    }
    
    override func configureVC() {
        restoreFrameYValue = self.view.frame.origin.y
        signUpButtonDidTap()
        resendButtonDidTap()
        certificationRequestButtonDidTap()
        
        bindUI()
        
        inputPhoneNumberTextfield.delegate = self
        certificationNumberTextfield.delegate = self
        
        navigationItem.title = "회원가입"
    }
    
    override func addView() {
        view.addSubviews(emailLabel,inputPhoneNumberTextfield, certificationRequestButton,
                         certificationNumberTextfield, warningLabel, signUpButton,
                         resendLabel, resendButton)
        
        certificationNumberTextfield.addSubview(countLabel)
    }
    
    override func setLayout() {
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(70)
            $0.leading.equalToSuperview().inset(26)
        }
        
        inputPhoneNumberTextfield.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(25)
            $0.leading.equalToSuperview().inset(26)
            $0.trailing.equalTo(certificationRequestButton.snp.leading).offset(-10)
            $0.height.equalTo(51)
        }
        
        certificationRequestButton.snp.makeConstraints {
            $0.top.equalTo(inputPhoneNumberTextfield.snp.top)
            $0.trailing.equalToSuperview().inset(26)
            $0.width.equalTo(inputPhoneNumberTextfield.snp.width).multipliedBy(0.4)
            $0.height.equalTo(51)
        }
        
        certificationNumberTextfield.snp.makeConstraints {
            $0.top.equalTo(inputPhoneNumberTextfield.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(51)
        }
        
        countLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(25)
        }
        
        resendLabel.snp.makeConstraints {
            $0.centerY.equalTo(resendButton)
            $0.centerX.equalToSuperview().offset(-20)
        }
        
        resendButton.snp.makeConstraints {
            $0.top.equalTo(certificationNumberTextfield.snp.bottom).offset(15)
            $0.leading.equalTo(resendLabel.snp.trailing).offset(8)
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
