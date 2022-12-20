//
//  postModel.swift
//  Choice
//
//  Created by 민도현 on 2022/12/20.
//  Copyright © 2022 com.dohyeon. All rights reserved.
//

import Foundation

class PostModel: Codable {
    var idx: String?
    var thumbnail: String?
    var title: String?
    var content: String?
    var firstVotingOption: String?
    var secondVotingOtion: String?
    var firstVotingCount: Int?
    var secondVotingCount: Int?
}
