//
//  ProfileCoordinator.swift
//  Choice
//
//  Created by 민도현 on 2022/12/29.
//  Copyright © 2022 com.dohyeon. All rights reserved.
//

import Foundation

class ProfileCoordinator: BaseCoordinator {
    override func start() {
        let vm = ProfileViewModel(coordinator: self)
        let vc = ProfileViewController(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
}
