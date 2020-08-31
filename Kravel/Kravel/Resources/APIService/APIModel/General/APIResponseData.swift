//
//  APIResponseData.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/31.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

protocol Errorable: Codable {}

struct APIResponseData<T: Codable, E: Codable>: Codable {
    let message: String
    let timestamp: String
    let data: T?
    let error: E?
    
    enum CodingKeys: String, CodingKey {
        case message
        case timestamp
        case data
        case error
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        timestamp = (try? values.decode(String.self, forKey: .timestamp)) ?? ""
        data = (try? values.decode(T.self, forKey: .data)) ?? nil
        error = (try? values.decode(E.self, forKey: .error)) ?? nil
    }
}
