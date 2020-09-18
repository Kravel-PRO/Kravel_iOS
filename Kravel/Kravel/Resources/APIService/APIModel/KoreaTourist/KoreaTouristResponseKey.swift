//
//  KoreaTouristResponseKey.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/11.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

enum KoreaTouristResponseKey: String {
    case item = "item"
    case addr1 = "addr1"
    case firstimage = "firstimage"
    case firstimage2 = "firstimage2"
    case mapx = "mapx"
    case mapy = "mapy"
    case title = "title"
}

struct KoreaTourist {
    var addr1: String
    var firstimage: String
    var firstimage2: String
    var mapx: Double
    var mapy: Double
    var title: String
}
