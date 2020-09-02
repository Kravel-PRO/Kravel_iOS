//
//  GetPlaceResponseData.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/03.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct GetPlaceResponseData: Codable {
    let result: GetPlaceResult?

    enum CodingKeys: String, CodingKey {
        case result
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = (try? values.decode(GetPlaceResult.self, forKey: .result)) ?? nil
    }
}

struct GetPlaceResult: Codable {
    let content: [PlaceContentInform]
    let pageable: Pageable
    let totalPages: Int
    let totalElements: Int
    let last: Bool
    let sort: Sort
    let size: Int
    let number: Int
    let numberOfElements: Int
    let first: Bool
    let empty: Bool
}

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

struct Pageable: Codable {
    let sort: Sort
    let offset: Int
    let pageNumber: Int
    let pageSize: Int
    let paged: Bool
    let unpaged: Bool
}

struct Sort: Codable {
    let sorted: Bool
    let unsorted: Bool
    let empty: Bool
}

