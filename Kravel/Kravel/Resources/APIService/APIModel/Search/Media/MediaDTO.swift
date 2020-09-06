//
//  MediaDTO.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/06.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct MediaDTO: Codable {
    let mediaId: Int
    let title: String
    let imageUrl: String?
    let year: Int
}
