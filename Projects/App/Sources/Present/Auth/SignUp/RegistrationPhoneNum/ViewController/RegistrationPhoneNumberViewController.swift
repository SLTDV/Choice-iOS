import UIKit
import RxSwift
import RxCocoa
import Shared

final class RegistrationPhoneNumberViewController: BaseVC<RegistrationPhoneNumberViewModel> {
    private let disposeBag = DisposeBag()
    
    private var isValidAuth = true
    
    private lazy var restoreFrameYValue = 0.0
    
    private let emailLabel = UILabel().then {
        $0.text = "전화번호"
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    private let inputPhoneNumberTextfield = BoxTextField().then {
        $0.placeholder = "전화번호 입력"
        $0.keyboardType = .numberPad
    }
    
    private let certificationRequestButton = UIButton().then {
        $0.setTitle("인증 요청", for: .normal)
        $0.isEnabled = false
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.backgroundColor = SharedAsset.grayVoteButton.color
        $0.layer.cornerRadius = 8
    }
    
    private let certificationNumberTextfield = BoxTextField().then {
        $0.placeholder = "인증번호 입력"
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
    
    private lazy var nextButton = UIButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.setTitle("다음", for: .normal)
        $0.isEnabled = false
        $0.backgroundColor = SharedAsset.grayVoteButton.color
        $0.layer.cornerRadius = 8
    }
    
    private let warningLabel = WarningLabel()
    
    private func nextButtonDidTap() {
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                LoadingIndicator.showLoading(text: "")
                owner.checkAuthCode()
            }.disposed(by: disposeBag)
    }
    
    private func checkAuthCode() {
        guard let phoneNumber = inputPhoneNumberTextfield.text else { return }
        guard let authCode = certificationNumberTextfield.text else { return }
        
        self.viewModel.requestAuthNumberConfirmation(phoneNumber: phoneNumber, authCode: authCode) { [weak self] isVaild in
            if isVaild {
                self?.viewModel.pushRegistrationPasswordVC(phoneNumber: phoneNumber)
            } else {
                self?.warningLabel.show(warning: "*인증번호가 일치하지 않습니다")
            }
            LoadingIndicator.hideLoading()
        }
    }
    
    private func bindUI() {
        let maxLength = 4
        
        certificationNumberTextfield.rx.text.orEmpty
            .map { text -> (Bool, String) in
                let isValid = (text.count == maxLength)
                let truncatedText = String(text.prefix(maxLength))
                return (isValid, truncatedText)
            }
            .bind(with: self, onNext: { owner, result in
                let (isValid, text) = result
                owner.nextButton.backgroundColor = isValid ? .black : SharedAsset.grayVoteButton.color
                owner.nextButton.isEnabled = isValid
                owner.certificationNumberTextfield.text = text
            }).disposed(by: disposeBag)
            
        inputPhoneNumberTextfield.rx.text.orEmpty
            .map { $0.count == 11 }
            .bind(with: self) { owner, isValid in
                owner.certificationRequestButton.backgroundColor = isValid ? .black : SharedAsset.grayVoteButton.color
                owner.certificationRequestButton.isEnabled = isValid
            }.disposed(by: disposeBag)
    }
    
    private func certificationRequestButtonDidTap() {
        let phoneNumberObservable = inputPhoneNumberTextfield.rx.text.orEmpty
        
        certificationRequestButton.rx.tap
            .withLatestFrom(phoneNumberObservable)
            .bind(with: self) { owner, inputPhoneNumber in
                LoadingIndicator.showLoading(text: "")
                
                guard inputPhoneNumber.hasPrefix("010") else {
                    owner.warningLabel.show(warning: "*전화번호 형식이 올바르지 않아요.")
                    LoadingIndicator.hideLoading()
                    return
                }
                
                owner.viewModel.requestAuthNumber(phoneNumber: inputPhoneNumber) { isValid in
                    if isValid {
                        owner.setupPossibleBackgroundTimer()
                        
                        owner.certificationNumberTextfield.isHidden = false
                        owner.resendLabel.isHidden = false
                        owner.resendButton.isHidden = false
                        
                        owner.certificationRequestButton.backgroundColor = SharedAsset.grayVoteButton.color
                        owner.certificationRequestButton.isEnabled = false
                        
                        owner.inputPhoneNumberTextfield.isUserInteractionEnabled = false
                        owner.inputPhoneNumberTextfield.textColor = .placeholderText
                        owner.warningLabel.hide()
                    } else {
                        owner.warningLabel.show(warning: "*이미 인증된 전화번호입니다")
                    }
                    
                    LoadingIndicator.hideLoading()
                }
                owner.view.endEditing(true)
            }.disposed(by: disposeBag)
    }
    
    private func resendButtonDidTap() {
        let phoneNumberObservable = inputPhoneNumberTextfield.rx.text.orEmpty
        
        resendButton.rx.tap
            .withLatestFrom(phoneNumberObservable)
            .bind(with: self) { owner, inputPhoneNumber in
                LoadingIndicator.showLoading(text: "")
                
                if !owner.isValidAuth {
                    owner.warningLabel.show(warning: "*3분 후에 다시 시도해주세요")
                    LoadingIndicator.hideLoading()
                    return
                }
                
                owner.viewModel.requestAuthNumber(phoneNumber: inputPhoneNumber) { isValid in
                    if isValid {
                        owner.setupPossibleBackgroundTimer()
                        owner.warningLabel.hide()
                    } else {
                        owner.warningLabel.show(warning: "*이미 인증된 전화번호입니다")
                    }
                    
                    LoadingIndicator.hideLoading()
                }
            }.disposed(by: disposeBag)
    }
    
    private func setupPossibleBackgroundTimer() {
        let count = 180
        
        isValidAuth = false
        
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .take(count+1)
            .map { count - $0 }
            .bind(with: self) { owner, remainingSeconds in
                let minutes = remainingSeconds / 60
                let seconds = remainingSeconds % 60
                owner.countLabel.text = String(format: "%02d:%02d", minutes, seconds)
                
                if remainingSeconds == 0 {
                    owner.countLabel.text = "00:00"
                    owner.isValidAuth = true
                }
            }.disposed(by: disposeBag)
    }
    
    private func testPassword(password: String) -> Bool {
        return viewModel.isValidPassword(password: password)
    }
    
    override func configureVC() {
        restoreFrameYValue = self.view.frame.origin.y
        nextButtonDidTap()
        resendButtonDidTap()
        certificationRequestButtonDidTap()
        
        bindUI()
        
        navigationItem.title = "회원가입"
    }
    
    override func addView() {
        view.addSubviews(emailLabel,inputPhoneNumberTextfield, certificationRequestButton,
                         certificationNumberTextfield, warningLabel, nextButton,
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
            $0.height.equalTo(58)
        }
        
        certificationRequestButton.snp.makeConstraints {
            $0.top.equalTo(inputPhoneNumberTextfield.snp.top)
            $0.trailing.equalToSuperview().inset(26)
            $0.width.equalTo(inputPhoneNumberTextfield.snp.width).multipliedBy(0.4)
            $0.height.equalTo(58)
        }
        
        certificationNumberTextfield.snp.makeConstraints {
            $0.top.equalTo(inputPhoneNumberTextfield.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(58)
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
