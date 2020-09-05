//
//  GetReviewParameter.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/03.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

protocol ReviewParameterAble: ParameterAble {}

struct GetReviewParameter: ReviewParameterAble {
    let page: Int?
    let size: Int?
    let sort: String?
}

struct GetReviewOfPlaceParameter: ReviewParameterAble {
    let latitude: Double?
    let longitude: Double?
    let like_count: Bool?
}
