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
    var likeCount: Int?
    var like: Bool?
    let createdDate: String?
    let place: PlaceDataOfReview?
    let modifiedDate: String?
    
    enum CodingKeys: String, CodingKey {
        case reviewId, imageUrl, likeCount, like, createdDate, place, modifiedDate
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        reviewId = (try? values.decode(Int.self, forKey: .reviewId)) ?? nil
        imageUrl = (try? values.decode(String.self, forKey: .imageUrl)) ?? nil
        likeCount = (try? values.decode(Int.self, forKey: .likeCount)) ?? nil
        like = (try? values.decode(Bool.self, forKey: .like)) ?? nil
        createdDate = (try? values.decode(String.self, forKey: .createdDate)) ?? nil
        place = (try? values.decode(PlaceDataOfReview.self, forKey: .place)) ?? nil
        modifiedDate = (try? values.decode(String.self, forKey: .modifiedDate)) ?? nil
    }
}
