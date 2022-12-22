//
//  MainCoordinator.swift
//  Choice
//
//  Created by 민도현 on 2022/12/19.
//  Copyright © 2022 com.dohyeon. All rights reserved.
//

import Foundation

class MainCoordinator: BaseCoordinator {
    override func start() {
        let vm = MainViewModel(coordinator: self)
        let vc = MainViewController(viewModel: vm)
        
        navigationController.setViewControllers([vc], animated: true)
    }
}
