//
//  APIDataResult.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/03.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct APIDataResult<C: Codable>: Codable {
    let result: APISortableResponseData<C>?
    
    enum CodingKeys: String, CodingKey {
        case result
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = (try? values.decode(APISortableResponseData.self, forKey: .result)) ?? nil
    }
}
