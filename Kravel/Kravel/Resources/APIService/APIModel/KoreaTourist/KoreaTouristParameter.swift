//
//  KoreaTouristQuery.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/11.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

enum KoreaTouristParameterKey: String {
    case serviceKey = "ServiceKey"
    case mobileOS = "MobileOS"
    case mobileApp = "MobileApp"
    case pageNo = "pageNo"
    case numberOfRows = "numberOfRows"
    case mapX = "mapX"
    case mapY = "mapY"
    case radius = "radius"
    case arrange = "arrange"
    case listYN = "listYN"
}

struct KoreaTouristParameter: ParameterAble {
    let serviceKey: String = PrivateKey.koreaTouristKey
    let mobileOS: String = "IOS"
    let mobileApp: String = "Kravel"
    let numberOfRows: Int = 10
    let pageNo: Int
    let mapX: Double
    let mapY: Double
    let radius: Int = 3000
    let listYN: String = "Y"
    
    // Default로 'E' 사용 -> 거리순 정렬
    let arrange: String = "E"
}
