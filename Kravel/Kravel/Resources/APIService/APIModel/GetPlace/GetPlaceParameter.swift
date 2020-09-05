//
//  GetPlaceParameter.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/03.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct GetPlaceParameter: ParameterAble {
    let latitude: Double?
    let longitude: Double?
    let page: Int?
    let size: Int?
    let review_count: Bool?
    let sort: String?
}
