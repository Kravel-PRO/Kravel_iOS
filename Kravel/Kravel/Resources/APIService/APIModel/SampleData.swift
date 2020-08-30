//
//  SampleData.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/30.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct SampleData: Codable {
    let lastBuildDate: Date?
    let total: Int
    let start: Int
    let display: Int
    let category: String
    let items: [MapData]
    
    enum CodingKeys: String, CodingKey {
        case lastBuildDate = "lastBulidDate"
        case total = "total"
        case start = "start"
        case display = "display"
        case category = "category"
        case items = "items"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lastBuildDate = (try? values.decode(Date.self, forKey: .lastBuildDate)) ?? nil
        total = (try? values.decode(Int.self, forKey: .total)) ?? 0
        start = (try? values.decode(Int.self, forKey: .start)) ?? 0
        display = (try? values.decode(Int.self, forKey: .display)) ?? 0
        category = (try? values.decode(String.self, forKey: .category)) ?? ""
        items = (try? values.decode([MapData].self, forKey: .items)) ?? []
    }
}

struct MapData: Codable {
    let title: String
    let link: String
    let description: String
    let telephone: String
    let address: String
    let roadAddress: String
    let mapx: Int
    let mapy: Int
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case link = "link"
        case description = "description"
        case telephone = "telephone"
        case address = "address"
        case roadAddress = "roadAddress"
        case mapx = "mapx"
        case mapy = "mapy"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = (try? values.decode(String.self, forKey: .title)) ?? ""
        link = (try? values.decode(String.self, forKey: .link)) ?? ""
        description = (try? values.decode(String.self, forKey: .description)) ?? ""
        telephone = (try? values.decode(String.self, forKey: .telephone)) ?? ""
        address = (try? values.decode(String.self, forKey: .address)) ?? ""
        roadAddress = (try? values.decode(String.self, forKey: .roadAddress)) ?? ""
        mapx = (try? values.decode(Int.self, forKey: .mapx)) ?? 0
        mapy = (try? values.decode(Int.self, forKey: .mapy)) ?? 0
    }
}
