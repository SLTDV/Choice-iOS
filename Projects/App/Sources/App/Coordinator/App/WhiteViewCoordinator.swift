//
//  WhiteViewController.swift
//  Choice
//
//  Created by 민도현 on 2023/05/26.
//  Copyright © 2023 dohyeon. All rights reserved.
//

import UIKit

class WhiteViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .white
    }
}


class WhiteViewCoordinator: BaseCoordinator {
    override func start() {
        let vc = WhiteViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}
