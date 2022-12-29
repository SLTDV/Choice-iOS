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
    
    override func navigate(to step: ChoiceStep) {
        switch step {
        case .addPostIsRequired:
            addPostIsRequired()
        case .detailPostIsRequired(let model):
            detailPostIsRequired(model: model)
        default:
            return
        }
    }
}

extension MainCoordinator {
    private func addPostIsRequired() {
        let vc = AddPostCoordiantor(navigationController: navigationController)
        vc.parentCoordinator = self
        childCoordinators.append(vc)
        vc.start()
    }
    
    private func detailPostIsRequired(model: PostModel) {
        let vc = DetailPostCoordiantor(navigationController: navigationController)
        vc.parentCoordinator = self
        childCoordinators.append(vc)
        vc.startDetailPostVC(model: model)
    }
}
