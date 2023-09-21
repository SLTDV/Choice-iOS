import UIKit
import RxSwift
import RxCocoa
import DesignSystem

final class RegistrationPhoneNumberViewController: BaseVC<RegistrationPhoneNumberViewModel>, InputPhoneNumberComponentProtocol {
    private let disposeBag = DisposeBag()

    private lazy var restoreFrameYValue = 0.0
    
    private let component = InputphoneNumberComponent()
    
    override func configureVC() {
        restoreFrameYValue = self.view.frame.origin.y
        
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
    
    private func testPassword(password: String) -> Bool {
        return viewModel.isValidPassword(password: password)
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
            component.warningLabel.show(warning: "*전화번호 형식이 올바르지 않아요. (ex.01011112222)")
            LoadingIndicator.hideLoading()
            return
        }
        
        viewModel.requestAuthNumber(phoneNumber: phoneNumber) { [weak self] isValid in
            if isValid {
                self?.component.setupPossibleBackgroundTimer()
                
                self?.component.authNumberTextfield.isHidden = false
                self?.component.resendLabel.isHidden = false
                self?.component.resendButton.isHidden = false
                
                self?.component.requestAuthButton.backgroundColor = DesignSystemAsset.Colors.grayVoteButton.color
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
    
    func resendButtonDidTap(phoneNumber: String) {
        LoadingIndicator.showLoading(text: "")
        
        viewModel.requestAuthNumber(phoneNumber: phoneNumber) { [weak self] isValid in
            if isValid {
                self?.component.setupPossibleBackgroundTimer()
                self?.component.warningLabel.hide()
            } else {
                self?.component.warningLabel.show(warning: "*이미 인증된 전화번호입니다")
            }
            
            self?.component.resendButton.isHidden = true
            self?.component.resendLabel.isHidden = true
            
            LoadingIndicator.hideLoading()
        }
    }
}
