//
//  APIErrorType.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/01.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct APIError: Codable {
    let errorMessage: String?
    let path: String?
    
    enum CodingKeys: String, CodingKey {
        case errorMessage
        case path
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        errorMessage = (try? values.decode(String.self, forKey: .errorMessage)) ?? nil
        path = (try? values.decode(String.self, forKey: .path)) ?? nil
    }
}
