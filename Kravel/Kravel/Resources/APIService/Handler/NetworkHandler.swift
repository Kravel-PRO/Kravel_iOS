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
    
    func requestAPI<P: ParameterAble>(apiCategory: APICategory<P>, completion: @escaping (NetworkResult<Codable>) -> Void) {
        
        let apiURL = apiCategory.makeURL()
        let headers = apiCategory.makeHeader()
        let parameters = apiCategory.makeParameter()
        
        switch apiCategory {
        case .signup: requestSignup(apiURL, headers, parameters, completion)
        case .signin: print("")
        }
    }
    
    private func requestSignup(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: APIResponseData<SignupResponseData, APIError>.self) { response in
                switch response.result {
                case .success(let signupData):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 { completion(.success(signupData.data?.result)) }
                    else { completion(.requestErr(signupData.error?.errorMessage)) }
                case .failure:
                    completion(.networkFail)
                }
        }
        
    }
}
