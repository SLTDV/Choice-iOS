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
    var secondVotingOption: String?
    var firstVotingCount: Int?
    var secondVotingCount: Int?
    
    init(idx: String?, thumbnail: String?, title: String?, content: String?,
         firstVotingOption: String?, secondVotingOption: String?, firstVotingCount: Int?, secondVotingCount: Int?) {
        self.idx = idx
        self.thumbnail = thumbnail
        self.title = title
        self.content = content
        self.firstVotingOption = firstVotingOption
        self.secondVotingOption = secondVotingOption
        self.firstVotingCount = firstVotingCount
        self.secondVotingCount = secondVotingCount
    }
}
