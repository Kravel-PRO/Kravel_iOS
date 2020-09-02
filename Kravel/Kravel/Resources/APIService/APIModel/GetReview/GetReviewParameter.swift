//
//  GetReviewParameter.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/03.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct GetReviewParameter: ParameterAble {
    let offset: Int
    let size: Int
    let sort: String
}
