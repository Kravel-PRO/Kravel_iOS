//
//  APICategory.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/01.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation
import Alamofire

protocol ParameterAble {}

enum APICategory<P: ParameterAble> {
    // P에 파라메터 변수 넣어 보내기
    case signup(P)
    case signin(P)
    case searchAddressNaver(P)
    
    func makeURL() -> String {
        switch self {
        case .signin: return APICostants.signin
        case .signup: return APICostants.signup
        case .searchAddressNaver: return APICostants.mapSearchBaseURL
        }
    }
    
    func makeHeader() -> HTTPHeaders? {
        switch self {
        case .signup:
            return [
                "Content-Type": "application/json"
            ]
        case .signin:
            return [
                "Content-Type": "application/json"
            ]
        case .searchAddressNaver:
            return [
                "Content-Type": "apllication/json",
                "X-Naver-Client-Id": PrivateKey.naverClientID,
                "X-Naver-Client-Secret": PrivateKey.naverClientSecret
            ]
        }
    }
    
    func makeParameter() -> Parameters? {
        switch self {
        case .signup(let signup):
            guard let signup = signup as? SignupParmeter else { return nil }
            return [
                "loginEmail": signup.loginEmail,
                "loginPw": signup.loginPw,
                "nickName": signup.nickName,
                "gender": signup.gender,
                "speech": signup.speech
            ]
        case .signin(let signin):
            guard let signin = signin as? SigninParameter else { return nil }
            return [
                "loginEmail": signin.loginEmail,
                "loginPw": signin.loginPw
            ]
        case .searchAddressNaver(let searchInform):
            guard let searchInform = searchInform as? NaverSearchParameter else { return nil }
            return [
                "query": searchInform.query,
                "display": searchInform.display!
            ]
        }
    }
}
