//
//  NaverSearchResponseData.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/02.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct NaverSearchResponseData: Codable {
    let rss: String?
    let channel: String?
    let lastBuildDate: String?
    let total: Int?
    let start: Int?
    let display: Int?
    let items: [PlaceInform]?
    
    enum CodingKeys: String, CodingKey {
        case rss
        case channel
        case lastBuildDate
        case total
        case start
        case display
        case items
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rss = (try? values.decode(String.self, forKey: .rss)) ?? nil
        channel = (try? values.decode(String.self, forKey: .channel)) ?? nil
        lastBuildDate = (try? values.decode(String.self, forKey: .lastBuildDate)) ?? nil
        total = (try? values.decode(Int.self, forKey: .total)) ?? nil
        start = (try? values.decode(Int.self, forKey: .start)) ?? nil
        display = (try? values.decode(Int.self, forKey: .display)) ?? nil
        items = (try? values.decode([PlaceInform].self, forKey: .items)) ?? nil
    }
}

struct PlaceInform: Codable {
    let title: String?
    let link: String?
    let category: String?
    let description: String?
    let telephone: String?
    let address: String?
    let roadAddress: String?
    let mapX: Int?
    let mapY: Int?
}
