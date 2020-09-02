//
//  GetPlaceResponseData.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/03.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct PlaceContentInform: Codable {
    let placeId: Int
    let title: String
    let imageUrl: String?
    let subImageUrl: String?
    let location: String
    let latitude: Double
    let longitude: Double
    let reviewCount: Int
    let tags: [String]?
    let celebrities: [PlaceCelebrity]
}

struct PlaceCelebrity: Codable {
    let celebrityId: Int
    let celebrityName: String
    let imageUrl: String
}
