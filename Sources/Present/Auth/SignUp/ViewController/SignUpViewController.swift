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
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 28, weight: .medium)
        $0.text = "Choice"
    }
     
    private let subTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .light)
        $0.textColor = .gray
        $0.text = "선택의 고민을 한 번에"
    }
    
    override func addView() {
    }
    
    override func setLayout() {
    }
}
