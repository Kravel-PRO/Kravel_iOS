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
    let title: String?
    let imageUrl: String?
    let subImageUrl: String?
    let location: String?
    let latitude: Double
    let longitude: Double
    let reviewCount: Int
    let tags: String?
    let celebrities: [CelebrityDTO]
}

struct PlaceDetailInform: Codable {
    let placeId: Int
    let title: String?
    let contents: [String]?
    let imageUrl: String?
    let location: String?
    let latitude: Double
    let longitude: Double
    let bus: String?
    let subway: String?
    var scrap: Bool
    let tags: String?
    let mediaId: Int
    let mediaTitle: String?
    let reviewCount: Int
    let celebrities: [CelebrityDTO]
}

struct PlaceDataOfReview: Codable {
    let placeId: Int
    let title: String
    let tags: String?
}
