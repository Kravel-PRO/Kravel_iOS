//
//  APIConstants.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/30.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct APICostants {
    static var placeID: String = ""
    
    // 카카오 오픈 API 주소 검색 주소
    static let mapSearchURL = "https://dapi.kakao.com/v2/local/search/keyword.json"
    
    // 서버 URL
    static let baseURL = "http://15.164.118.217:8080"
    
    // 로그인, 로그아웃 URL
    static let signin = APICostants.baseURL + "/auth/sign-in"
    static let signup = APICostants.baseURL + "/auth/sign-up"
    
    // 장소 가져오는 API
    static let getPlace = APICostants.baseURL + "/api/places"
    
    // 새로운 리뷰 가져오는 API
    static let getNewReview = APICostants.baseURL + "/api/reviews"
    static var getReviewOfID: String {
        get {
            return APICostants.baseURL + "/api/\(placeID)/reviews"
        }
        
        set (placeID) {
            self.placeID = placeID
        }
    }
}
