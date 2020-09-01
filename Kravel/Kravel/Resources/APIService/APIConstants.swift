//
//  APIConstants.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/30.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct APICostants {
    // 카카오 오픈 API 주소 검색 주소
    static let mapSearchURL = "https://dapi.kakao.com/v2/local/search/keyword.json"
    
    // 서버 URL
    static let baseURL = "http://15.164.118.217:8080"
    
    // 로그인, 로그아웃 URL
    static let signin = APICostants.baseURL + "/auth/sign-in"
    static let signup = APICostants.baseURL + "/auth/sign-up"
}
