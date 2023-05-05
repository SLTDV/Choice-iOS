//
//  MainCoordinator.swift
//  Choice
//
//  Created by 민도현 on 2022/12/19.
//  Copyright © 2022 com.dohyeon. All rights reserved.
//

import Foundation

class HomeCoordinator: BaseCoordinator {
    override func start() {
        let vm = HomeViewModel(coordinator: self)
        let vc = HomeViewController(viewModel: vm)
        
        navigationController.setViewControllers([vc], animated: true)
    }
    
    override func navigate(to step: ChoiceStep) {
        switch step {
        case .addPostIsRequired:
            addPostIsRequired()
        case .detailPostIsRequired(let model):
            detailPostIsRequired(model: model)
        case .profileIsRequired:
            profileIsRequired()
        default:
            return
        }
    }
}

extension HomeCoordinator {
    private func addPostIsRequired() {
        let vc = AddPostCoordiantor(navigationController: navigationController)
        vc.parentCoordinator = self
        childCoordinators.append(vc)
        vc.start()
    }
    
    private func detailPostIsRequired(model: Posts) {
        let vc = DetailPostCoordiantor(navigationController: navigationController)
        vc.parentCoordinator = self
        childCoordinators.append(vc)
        vc.startDetailPostVC(model: model)
    }
    
    private func profileIsRequired() {
        let vc = ProfileCoordinator(navigationController: navigationController)
        vc.parentCoordinator = self
        childCoordinators.append(vc)
        vc.start()
    }
}