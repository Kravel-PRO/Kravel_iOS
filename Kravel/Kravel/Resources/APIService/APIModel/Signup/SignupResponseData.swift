//
//  SignupData.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/31.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct SignupResponseData: Codable {
    let result: Int?
    
    enum CodingKeys: String, CodingKey {
        case result
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = (try? values.decode(Int.self, forKey: .result)) ?? nil
    }
}