//
//  APISortableResponseData.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/03.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct APISortableResponseData<C: Codable>: Codable {
    let content: [C]
    let pageable: Pageable
    let totalPages: Int, totalElements: Int
    let last: Bool
    let sort: Sort
    let size: Int, number: Int, numberOfElements: Int
    let first: Bool, empty: Bool
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
