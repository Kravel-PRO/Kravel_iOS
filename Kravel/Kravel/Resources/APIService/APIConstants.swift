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
    static var reviewID: String = ""
    
    // 카카오 오픈 API 주소 검색 주소
    static let mapSearchURL = "https://dapi.kakao.com/v2/local/search/keyword.json"
    
    // 한국 관광 공사 API 주소
    static let koreaTouristURL = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/locationBasedList?"
    static let engTouristURL = "http://api.visitkorea.or.kr/openapi/service/rest/EngService/locationBasedList?"
    
    // 서버 URL
    static let baseURL = "http://15.164.118.217:8080"
    
    // 로그인, 로그아웃 URL
    static let signin = APICostants.baseURL + "/auth/sign-in"
    static let signup = APICostants.baseURL + "/auth/sign-up"
    
    // 장소 가져오는 API
    static let getPlace = APICostants.baseURL + "/api/places"
    static var getPlaceOfID: String {
        get {
            return APICostants.baseURL + "/api/places/\(placeID)"
        }
    }
    
    // 맵 뷰 ID, 위도, 경도 가져오는 API
    static let map = APICostants.baseURL + "/api/places/map"
    
    // 새로운 리뷰 가져오는 API
    static let getReview = APICostants.baseURL + "/api/reviews"
    static var reviewOfId: String {
        get {
            return APICostants.baseURL + "/api/places/\(placeID)/reviews"
        }
    }
    
    // 스크랩 내용 여부 전달 API
    static var scrap: String {
        get {
            return APICostants.baseURL + "/api/places/\(placeID)/scrap"
        }
    }
    
    // 좋아요 전달하는 API
    static var like: String {
        get {
            return APICostants.baseURL + "/api/places/\(placeID)/reviews/\(reviewID)/likes"
        }
    }
    
    // 연예인 미디어 검색 ID
    static var mediaID: String = ""
    static var celebID: String = ""
    
    static var getDetailMedia: String {
        get {
            return APICostants.getMeidaList + "/\(mediaID)"
        }
    }
    
    static var getReviewOfMedia: String {
        get {
            return APICostants.getMeidaList + "/\(mediaID)" + "/reviews"
        }
    }
    
    static var getDetailCeleb: String {
        get {
            return APICostants.getCelebList + "/\(celebID)"
        }
    }
    
    static var getReviewOfCeleb: String {
        get {
            APICostants.getCelebList + "/\(celebID)" + "/reviews"
        }
    }
    
    // 연예인 검색 API
    static let getCelebList = APICostants.baseURL + "/api/celebrities"
    
    // 미디어 검색 API
    static let getMeidaList = APICostants.baseURL + "/api/medias"
    
    // 연예인, 미디어 검색 API
    static let search = APICostants.baseURL + "/api/search"
    
    static var infoTypeQuery: String = ""
    
    // 마이페이지 내 정보 수정
    static var changeInfo: String {
        get {
            APICostants.baseURL + "/api/member?type=\(infoTypeQuery)"
        }
    }
    
    // 내 포토리뷰 가져오기
    static let getMyPhotoReview = APICostants.baseURL + "/api/member/reviews"
    
    // 내 스크랩 가져오기
    static let getMyScrap = APICostants.baseURL + "/api/member/scraps"
    
    // 내 정보 불러오기
    static let getMyInform = APICostants.baseURL + "/api/members/me"
}
