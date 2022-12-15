//
//  SignInCoordinator.swift
//  Choice
//
//  Created by 민도현 on 2022/12/15.
//  Copyright © 2022 com.dohyeon. All rights reserved.
//

import Foundation

class SignInCoordinator: baseCoordinator {
    override func start() {
        let vm = SignInViewModel(coordinator: self)
        let vc = SignInViewController(viewModel: vm)
        
        navigationController.setViewControllers([vc], animated: true)
    }
}
