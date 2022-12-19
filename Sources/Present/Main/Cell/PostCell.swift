//
//  TableViewCell.swift
//  Choice
//
//  Created by 민도현 on 2022/12/19.
//  Copyright © 2022 com.dohyeon. All rights reserved.
//

import UIKit
import SnapKit
import Then

class PostCell: UITableViewCell {
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 12)
    }
        
    private let postImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
}
