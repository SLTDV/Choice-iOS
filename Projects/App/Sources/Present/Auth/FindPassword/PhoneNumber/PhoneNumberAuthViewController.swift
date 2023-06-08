import UIKit
import Shared
import RxSwift
import RxCocoa

class PhoneNumberAuthViewController: BaseVC<PhoneNumberAuthViewModel>, InputPhoneNumberComponentProtocol {
    private let component = InputphoneNumberComponent()
    
    override func configureVC() {
        component.delegate = self
    }
    
    override func addView() {
        view.addSubview(component)
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
                self?.viewModel.pushChangeToPassword(phoneNumber: phoneNumber)
            } else {
                self?.component.warningLabel.show(warning: "*인증번호가 일치하지 않습니다")
            }
            LoadingIndicator.hideLoading()
        }
    }
}

extension PhoneNumberAuthViewController {
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
                self?.component.setupPossibleBackgroundTimer()
                
                self?.component.authNumberTextfield.isHidden = false
                self?.component.resendLabel.isHidden = false
                self?.component.resendButton.isHidden = false
                
                self?.component.requestAuthButton.backgroundColor = SharedAsset.grayVoteButton.color
                self?.component.requestAuthButton.isEnabled = false
                
                self?.component.inputPhoneNumberTextfield.isUserInteractionEnabled = false
                self?.component.inputPhoneNumberTextfield.textColor = .placeholderText
                self?.component.warningLabel.hide()
            } else {
                self?.component.warningLabel.show(warning: "전화번호를 찾을 수 없습니다.")
            }
            
            LoadingIndicator.hideLoading()
        }
        view.endEditing(true)
    }
    
    func resendButtonDidTap(phoneNumber: String) {
        LoadingIndicator.showLoading(text: "")
        
        guard component.isValidAuth else {
            component.warningLabel.show(warning: "*3분 후에 다시 시도해주세요")
            LoadingIndicator.hideLoading()
            return
        }
        
        viewModel.requestAuthNumber(phoneNumber: phoneNumber) { [weak self] isValid in
            if isValid {
                self?.component.setupPossibleBackgroundTimer()
                self?.component.warningLabel.hide()
            } else {
                self?.component.warningLabel.show(warning: "*이미 인증된 전화번호입니다")
            }
            
            LoadingIndicator.hideLoading()
        }
    }
}
