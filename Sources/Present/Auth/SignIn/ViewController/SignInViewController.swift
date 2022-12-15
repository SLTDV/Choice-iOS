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
        $0.text = "셀렉트"
        $0.textColor = .black
        $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 28)
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "선택의 고민을 한 번에"
        $0.textColor = .black
        $0.font = UIFont(name: "AppleSDGothicNeo-Light", size: 16)
    }
    
    override func addView() {
        view.addSubviews(subView: titleLabel, subTitleLabel)
    }
}

