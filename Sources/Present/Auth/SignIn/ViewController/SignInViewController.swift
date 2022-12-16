//
//  SignInViewController.swift
//  Choice
//
//  Created by 민도현 on 2022/12/15.
//  Copyright © 2022 com.dohyeon. All rights reserved.
//

import UIKit

class SignInViewController: BaseVC<SignInViewModel> {
    private let titleLabel = UILabel().then {
        $0.text = "Choice"
        $0.textColor = .black
        $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 28)
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "선택의 고민을 한 번에"
        $0.textColor = .gray
        $0.font = UIFont(name: "AppleSDGothicNeo-Light", size: 16)
    }
    
    private let inputIdTextField = UnderLineTextField().then {
        $0.setPlaceholder(placeholder: "이메일")
    }
    
    private let inputPasswordTextField = UnderLineTextField().then {
        $0.setPlaceholder(placeholder: "비밀번호")
    }
    
    private let loginButtoon = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = .init(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)
        $0.layer.cornerRadius = 8
        $0.titleLabel?.textColor = .white
    }
    
    override func addView() {
        view.addSubviews(titleLabel, subTitleLabel, inputIdTextField, inputPasswordTextField, loginButtoon)
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
        
        inputIdTextField.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(77)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
        
        inputPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(inputIdTextField.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
    
        loginButtoon.snp.makeConstraints {
            $0.top.equalTo(inputPasswordTextField.snp.bottom).offset(52)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(49)
        }
    }
}

