//
//  GetSimplePlaceResponseData.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/06.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct SimplePlace: Codable {
    let placeId: Int
    let latitude: Double
    let longitude: Double
}
