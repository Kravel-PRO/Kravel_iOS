//
//  APICategory.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/01.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation
import Alamofire

extension Int: ParameterAble {}

protocol ParameterAble {}

enum APICategory<P: ParameterAble> {
    // P에 파라메터 변수 넣어 보내기
    case signup(P)
    case signin(P)
    case searchPlaceKakao(P)
    case getPlace(P)
    case getSimplePlace(P)
    case getPlaceOfID(P)
    case getNewReview(P)
    case getPlaceReview(P)
    case scrap(P)
    
    func makeURL() -> String {
        switch self {
        case .signin: return APICostants.signin
        case .signup: return APICostants.signup
        case .searchPlaceKakao: return APICostants.mapSearchURL
        case .getPlace: return APICostants.getPlace
        case .getSimplePlace: return APICostants.map
        case .getPlaceOfID(let id):
            guard let id = id as? Int else { return "" }
            APICostants.placeID = "\(id)"
            return APICostants.getPlaceOfID
        case .getNewReview: return APICostants.getNewReview
        case .getPlaceReview: return APICostants.getReviewOfID
        case .scrap: return APICostants.scrap
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
        case .searchPlaceKakao:
            return [
                "Content-Type": "application/json",
                "Authorization": "KakaoAK \(PrivateKey.kakaoRESTAPIKey)"
            ]
        case .getPlace:
            guard let token = UserDefaults.standard.object(forKey: UserDefaultKey.token) as? String else { return nil }
            return [
                "Content-Type": "application/json",
                "Authorization": token
            ]
        case .getSimplePlace:
            guard let token = UserDefaults.standard.object(forKey: UserDefaultKey.token) as? String else { return nil }
            return [
                "Content-Type": "application/json",
                "Authorization": token
            ]
        case .getPlaceOfID:
            guard let token = UserDefaults.standard.object(forKey: UserDefaultKey.token) as? String else { return nil }
            return [
                "Content-Type": "application/json",
                "Authorization": token
            ]
        case .getNewReview:
            guard let token = UserDefaults.standard.object(forKey: UserDefaultKey.token) as? String else { return nil }
            return [
                "Content-Type": "application/json",
                "Authorization": token
            ]
        case .getPlaceReview:
            guard let token = UserDefaults.standard.object(forKey: UserDefaultKey.token) as? String else { return nil }
            return [
                "Content-Type": "application/json",
                "Authorization": token
            ]
        case .scrap:
            guard let token = UserDefaults.standard.object(forKey: UserDefaultKey.token) as? String else { return nil }
            return [
                "Content-Type": "application/json",
                "Authorization": token
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
        case .searchPlaceKakao(let kakaoParameter):
            guard let kakaoParameter = kakaoParameter as? SearchPlaceParameter else { return nil }
            return [
                "query": kakaoParameter.query,
                "page": kakaoParameter.page
            ]
        case .getPlace(let placeParameter):
            guard let getPlaceParameter = placeParameter as? GetPlaceParameter else { return nil }
            
            var parameters: [String: Any] = [:]
            if let latitude = getPlaceParameter.latitude,
                let longtitude = getPlaceParameter.longitude {
                parameters.updateValue(latitude, forKey: "latitude")
                parameters.updateValue(longtitude, forKey: "longtitude")
            }
            
            if let offset = getPlaceParameter.page {
                parameters.updateValue(offset, forKey: "page")
            }
            
            if let size = getPlaceParameter.size {
                parameters.updateValue(size, forKey: "size")
            }
            
            if let review_count = getPlaceParameter.review_count {
                parameters.updateValue(review_count, forKey: "review-count")
            }
            
            if let sort = getPlaceParameter.sort {
                parameters.updateValue(sort, forKey: "sort")
            }
            return parameters
        case .getSimplePlace(let simplePlaceParameter):
            guard let simplePlaceParameter = simplePlaceParameter as? GetSimplePlaceParameter else { return nil }
            var parameters: [String: Any] = [:]
            
            if let latitude = simplePlaceParameter.latitude,
                let longitude = simplePlaceParameter.longitude {
                parameters.updateValue(latitude, forKey: "latitude")
                parameters.updateValue(longitude, forKey: "longitude")
            }
            return parameters
        case .getPlaceOfID: return nil
        case .getNewReview(let reviewParameter):
            var parameters: [String: Any] = [:]
            guard let reviewParameter = reviewParameter as? GetReviewParameter else { return nil }
            if let offset = reviewParameter.page {
                parameters.updateValue(offset, forKey: "page")
            }
            
            if let size = reviewParameter.size {
                parameters.updateValue(size, forKey: "size")
            }
            
            if let sort = reviewParameter.sort {
                parameters.updateValue(sort, forKey: "sort")
            }
            return parameters
        case .getPlaceReview(let reviewOfPlaceParameter):
            var parameters: [String: Any] = [:]
            guard let reviewOfPlaceParameter = reviewOfPlaceParameter as? GetReviewOfPlaceParameter else { return nil }
            if let latitude = reviewOfPlaceParameter.latitude {
                parameters.updateValue(latitude, forKey: "latitude")
            }
            
            if let longitude = reviewOfPlaceParameter.longitude {
                parameters.updateValue(longitude, forKey: "longitude")
            }
            
            if let like_count = reviewOfPlaceParameter.like_count {
                parameters.updateValue(like_count, forKey: "like-count")
            }
            return parameters
        case .scrap(let scrapParameter):
            guard let scrapParameter = scrapParameter as? ScrapParameter else { return nil }
            return [
                "scrap": scrapParameter.scrap
            ]
        }
    }
}
