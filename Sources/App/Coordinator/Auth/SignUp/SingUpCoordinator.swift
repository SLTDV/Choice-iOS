//
//  SingUpCoordinator.swift
//  Choice
//
//  Created by 곽희상 on 2022/12/16.
//  Copyright © 2022 com.dohyeon. All rights reserved.
//

import Foundation

class SignIUpCoordinator: BaseCoordinator {
    override func start() {
        let vm = SignUpViewModel(coordinator: self)
        let vc = SignUpViewController(viewModel: vm)
        
        navigationController.setViewControllers([vc], animated: true)
    }
}
