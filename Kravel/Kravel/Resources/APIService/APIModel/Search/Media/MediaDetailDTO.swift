//
//  MediaDetailDTO.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/08.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct MediaDetailDTO: Codable, CategoryAble {
    let mediaId: Int
    let title: String
    let imageUrl: String?
    // FIXME: 여기는 뭐가 들어가는거지..?
    let contents: [String]?
    let places: [PlaceContentInform]?
    let year: String
}
