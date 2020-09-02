//
//  GetReviewResponseData.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/03.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct ReviewInform: Codable {
    let reviewId: Int
    let imageURl: String
    let grade: Double
    let likeCount: Int
}
