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
        case .signin: requestSignin(apiURL, headers, parameters, completion)
        case .searchPlaceKakao: requestSearchPlace(apiURL, headers, parameters, completion)
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
    
    private func requestSignin(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: APIResponseData<SigninResponseData, APIError>.self) { response in
                switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 {
                        guard let token = response.response?.headers["Authorization"] else { return }
                        completion(.success(token))
                    } else { completion(.requestErr("실패")) }
                case .failure:
                    completion(.networkFail)
                }
        }
    }
    
    private func requestSearchPlace(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: SearchPlaceResponseData.self) { response in
                switch response.result {
                case .success(let placeResult):
                    print(placeResult)
                    print(response.response?.statusCode)
                case .failure(let error):
                    print(error)
                }
        }
    }
}
