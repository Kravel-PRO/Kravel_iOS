//
//  GetReviewResponseData.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/03.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct ReviewInform: Codable {
    let reviewId: Int?
    let imageUrl: String?
    let likeCount: Int?
    let like: Bool?
    let createdDate: String?
    let placeTitle: String?
    let tags: String?
    
    enum CodingKeys: String, CodingKey {
        case reviewId, imageUrl, likeCount, like, createdDate, placeTitle, tags
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        reviewId = (try? values.decode(Int.self, forKey: .reviewId)) ?? nil
        imageUrl = (try? values.decode(String.self, forKey: .imageUrl)) ?? nil
        likeCount = (try? values.decode(Int.self, forKey: .likeCount)) ?? nil
        like = (try? values.decode(Bool.self, forKey: .like)) ?? nil
        createdDate = (try? values.decode(String.self, forKey: .createdDate)) ?? nil
        placeTitle = (try? values.decode(String.self, forKey: .placeTitle)) ?? nil
        tags = (try? values.decode(String.self, forKey: .tags)) ?? nil
    }
}
