//
//  MainViewController.swift
//  Choice
//
//  Created by 민도현 on 2022/12/19.
//  Copyright © 2022 com.dohyeon. All rights reserved.
//

import UIKit

class MainViewController: BaseVC<MainViewModel> {
    
    private let addPostButton = UIBarButtonItem().then {
        $0.tintColor = .black
        $0.image = UIImage(systemName: "plus.app")
    }
    
    private let profileButton = UIBarButtonItem().then {
        $0.tintColor = .black
        $0.image = UIImage(systemName: "person.crop.circle.fill")
    }
    
    private let dropdownButton = UIButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.setTitle("정렬 ↓", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        $0.layer.cornerRadius = 5
    }
    
    override func configureVC() {
        navigationItem.title = "choice"
        navigationItem.rightBarButtonItems = [profileButton, addPostButton]
    }
    
    override func addView() {
        view.addSubviews(dropdownButton)
    }
    
    override func setLayout() {
        dropdownButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.trailing.equalToSuperview().inset(14)
            $0.width.equalTo(64)
            $0.height.equalTo(28)
        }
    }
}
