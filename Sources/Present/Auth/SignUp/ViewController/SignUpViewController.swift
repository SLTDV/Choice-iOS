//
//  SignUpViewController.swift
//  Choice
//
//  Created by 곽희상 on 2022/12/16.
//  Copyright © 2022 com.dohyeon. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Then

class SignUpViewController: BaseVC<SignUpViewModel> {
    
    lazy var restoreFrameYValue = 0.0
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 28, weight: .medium)
        $0.text = "Choice"
    }
     
    private let subTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .light)
        $0.textColor = .gray
        $0.text = "선택의 고민을 한 번에"
    }
    
    private let inputNicknameTextfield = UnderLineTextField().then {
        $0.setPlaceholder(placeholder: "닉네임")
    }
    
    private let inputIdTextfield = UnderLineTextField().then {
        $0.setPlaceholder(placeholder: "아이디")
    }
    
    private let inputPasswordTextfield = UnderLineTextField().then {
        $0.isSecureTextEntry = true
        $0.setPlaceholder(placeholder: "비밀번호")
    }
    
    private let inputCheckPasswordTextfield = UnderLineTextField().then {
        $0.isSecureTextEntry = true
        $0.setPlaceholder(placeholder: "비밀번호확인")
    }
    
    private let signUpButton = UIButton().then {
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.layer.cornerRadius = 8
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .init(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)
        $0.setTitle("회원가입", for: .normal)
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
        view.addSubviews(titleLabel, subTitleLabel, inputNicknameTextfield, inputIdTextfield, inputPasswordTextfield, inputCheckPasswordTextfield, signUpButton)
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
        
        inputIdTextfield.snp.makeConstraints {
            $0.top.equalTo(inputNicknameTextfield.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
        
        inputPasswordTextfield.snp.makeConstraints {
            $0.top.equalTo(inputIdTextfield.snp.bottom).offset(40)
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
