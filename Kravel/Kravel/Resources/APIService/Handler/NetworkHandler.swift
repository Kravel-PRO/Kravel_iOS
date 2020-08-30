//
//  NetworkHandler.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/30.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkHandler {
    static let shared = NetworkHandler()
    
    func getMapAPI() {
        guard let searchURL = URL(string: APICostants.mapSearchBaseURL+"?query=%EC%A3%BC%EC%8B%9D&display=10&start=1&sort=random") else { return }
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": "bqn4VJfXRzjDkkCkfXrt",
            "X-Naver-Client-Secret": "dUtMLQ4Tq3",
            "Content-Type": "application/json"
        ]
        
        AF.request(searchURL, method: .get, encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
        .responseDecodable(of: SampleData.self) { response in
            print(try? response.result.get())
            
        }

    }
}
