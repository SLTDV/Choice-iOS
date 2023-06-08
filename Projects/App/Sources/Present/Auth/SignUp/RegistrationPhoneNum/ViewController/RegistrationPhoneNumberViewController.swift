import UIKit
import RxSwift
import RxCocoa
import Shared

final class RegistrationPhoneNumberViewController: BaseVC<RegistrationPhoneNumberViewModel>, PhoneNumberComponentProtocol {
    private let disposeBag = DisposeBag()
    
    private var isValidAuth = true
    
    private lazy var restoreFrameYValue = 0.0
    
    private let component = InputphoneNumberComponent()
    
    private func bindUI() {
        let maxLength = 4
        
        component.authNumberTextfield.rx.text.orEmpty
            .map { text -> (Bool, String) in
                let isValid = (text.count == maxLength)
                let truncatedText = String(text.prefix(maxLength))
                return (isValid, truncatedText)
            }
            .bind(with: self, onNext: { owner, result in
                let (isValid, text) = result
                owner.component.nextButton.backgroundColor = isValid ? .black : SharedAsset.grayVoteButton.color
                owner.component.nextButton.isEnabled = isValid
                owner.component.authNumberTextfield.text = text
            }).disposed(by: disposeBag)
        
        component.inputPhoneNumberTextfield.rx.text.orEmpty
            .map { $0.count == 11 }
            .bind(with: self) { owner, isValid in
                print(isValid)
                owner.component.requestAuthButton.backgroundColor = isValid ? .black : SharedAsset.grayVoteButton.color
                owner.component.requestAuthButton.isEnabled = isValid
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
                owner.component.countLabel.text = String(format: "%02d:%02d", minutes, seconds)
                
                if remainingSeconds == 0 {
                    owner.component.countLabel.text = "00:00"
                    owner.isValidAuth = true
                }
            }.disposed(by: disposeBag)
    }
    
    private func testPassword(password: String) -> Bool {
        return viewModel.isValidPassword(password: password)
    }
    
    override func configureVC() {
        restoreFrameYValue = self.view.frame.origin.y
        
        bindUI()
        component.delegate = self
        
        navigationItem.title = "회원가입"
    }
    
    override func addView() {
        view.addSubviews(component)
    }
    
    override func setLayout() {
        component.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}


extension RegistrationPhoneNumberViewController {
    func nextButtonDidTap() {
        LoadingIndicator.showLoading(text: "")
        checkAuthCode()
    }
    
    func requestAuthButtonDidTap(phoneNumber: String) {
        LoadingIndicator.showLoading(text: "")
        
        guard phoneNumber.hasPrefix("010") else {
            component.warningLabel.show(warning: "*전화번호 형식이 올바르지 않아요.")
            LoadingIndicator.hideLoading()
            return
        }
        
        viewModel.requestAuthNumber(phoneNumber: phoneNumber) { [weak self] isValid in
            if isValid {
                self?.setupPossibleBackgroundTimer()
                
                self?.component.authNumberTextfield.isHidden = false
                self?.component.resendLabel.isHidden = false
                self?.component.resendButton.isHidden = false
                
                self?.component.requestAuthButton.backgroundColor = SharedAsset.grayVoteButton.color
                self?.component.requestAuthButton.isEnabled = false
                
                self?.component.inputPhoneNumberTextfield.isUserInteractionEnabled = false
                self?.component.inputPhoneNumberTextfield.textColor = .placeholderText
                self?.component.warningLabel.hide()
            } else {
                self?.component.warningLabel.show(warning: "*이미 인증된 전화번호입니다")
            }
            
            LoadingIndicator.hideLoading()
        }
        view.endEditing(true)
    }
    
    func resendButtonDidTap() {
        let phoneNumberObservable = component.inputPhoneNumberTextfield.rx.text.orEmpty
        
        component.resendButton.rx.tap
            .withLatestFrom(phoneNumberObservable)
            .bind(with: self) { owner, inputPhoneNumber in
                LoadingIndicator.showLoading(text: "")
                print(inputPhoneNumber)
                
                guard owner.isValidAuth else {
                    owner.component.warningLabel.show(warning: "*3분 후에 다시 시도해주세요")
                    LoadingIndicator.hideLoading()
                    return
                }
                
                owner.viewModel.requestAuthNumber(phoneNumber: inputPhoneNumber) { isValid in
                    print("request!!@#")
                    if isValid {
                        owner.setupPossibleBackgroundTimer()
                        owner.component.warningLabel.hide()
                    } else {
                        owner.component.warningLabel.show(warning: "*이미 인증된 전화번호입니다")
                    }
                    
                    LoadingIndicator.hideLoading()
                }
            }.disposed(by: disposeBag)
    }
    
    private func checkAuthCode() {
        guard let phoneNumber = component.inputPhoneNumberTextfield.text else { return }
        guard let authCode = component.authNumberTextfield.text else { return }
        
        self.viewModel.requestAuthNumberConfirmation(phoneNumber: phoneNumber, authCode: authCode) { [weak self] isVaild in
            if isVaild {
                self?.viewModel.pushRegistrationPasswordVC(phoneNumber: phoneNumber)
            } else {
                self?.component.warningLabel.show(warning: "*인증번호가 일치하지 않습니다")
            }
            LoadingIndicator.hideLoading()
        }
    }
}
