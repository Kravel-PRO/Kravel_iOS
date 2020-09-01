//
//  NaverMapSearchParameter.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/02.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct NaverSearchParameter: ParameterAble {
    let query: String
    let display: Int?
    let start: Int?
    let sort: String?
}
