//
//  MediaDetailDTO.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/08.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct MediaDetailDTO: Codable, CategoryAble {
    let media: MediaSimpleDTO
    let places: [PlaceContentInform]?
}

struct MediaSimpleDTO: Codable {
    let mediaId: Int
    let title: String
    let imageUrl: String?
    let contents: String?
    let year: String
}
