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
    
    override func configureVC() {
        navigationItem.rightBarButtonItems = [profileButton, addPostButton]
    }
}
