//
//  CelebrityDTO.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/06.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct CelebrityDTO: Codable {
    let celebrityId: Int
    let celebrityName: String?
    let imageUrl: String
}
