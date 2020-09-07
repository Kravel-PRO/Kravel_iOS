//
//  CelebrityDetailDTO.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/08.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct CelebrityDetailDTO: Codable, CategoryAble {
    let celebrity: CelebrityDTO
    let places: [PlaceContentInform]
}
