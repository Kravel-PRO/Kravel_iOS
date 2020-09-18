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
    case getReview(P)
    case getPlaceReview(P)
    case postPlaceReview(P)
    case scrap(P)
    case like(P, placeId: Int, reviewId: Int)
    case getCeleb(P)
    case getMedia(P)
    case search(P)
    case getCelebOfID(P)
    case getMediaOfID(P)
    case getReviewOfCeleb(P, id: Int)
    case getReviewOfMedia(P, id: Int)
    case getMyPhotoReview(P)
    case getMyScrap(P)
    case changInfo(queryType: String, body: P)
    case getMyInform(P)
    
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
        case .getReview: return APICostants.getReview
        case .getPlaceReview: return APICostants.reviewOfId
        case .postPlaceReview: return APICostants.reviewOfId
        case .like(_, let placeId, let reviewId):
            APICostants.placeID = "\(placeId)"
            APICostants.reviewID = "\(reviewId)"
            return APICostants.like
        case .scrap: return APICostants.scrap
        case .getCeleb: return APICostants.getCelebList
        case .getMedia: return APICostants.getMeidaList
        case .search: return APICostants.search
        case .getCelebOfID(let id):
            guard let id = id as? Int else { return "" }
            APICostants.celebID = "\(id)"
            return APICostants.getDetailCeleb
        case .getMediaOfID(let id):
            guard let id = id as? Int else { return "" }
            APICostants.mediaID = "\(id)"
            return APICostants.getDetailMedia
        case .getReviewOfCeleb(_, let id):
            APICostants.celebID = "\(id)"
            print(APICostants.getReviewOfCeleb)
            return APICostants.getReviewOfCeleb
        case .getReviewOfMedia(_, let id):
            APICostants.mediaID = "\(id)"
            return APICostants.getReviewOfMedia
        case .changInfo(let query, _):
            APICostants.infoTypeQuery = query
            return APICostants.changeInfo
        case .getMyPhotoReview:
            return APICostants.getMyPhotoReview
        case .getMyScrap:
            return APICostants.getMyScrap
        case .getMyInform:
            return APICostants.getMyInform
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
        case .postPlaceReview:
            guard let token = UserDefaults.standard.object(forKey: UserDefaultKey.token) as? String else { return nil }
            return [
                "Content-Type": "multipart/form-data",
                "Authorization": token
            ]
        default:
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
                parameters.updateValue(longtitude, forKey: "longitude")
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
        case .getReview(let reviewParameter):
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
            guard let reviewOfPlaceParameter = reviewOfPlaceParameter as? GetReviewParameter else { return nil }
            if let sort = reviewOfPlaceParameter.sort {
                parameters.updateValue(sort, forKey: "sort")
            }
            
            if let size = reviewOfPlaceParameter.size {
                parameters.updateValue(size, forKey: "size")
            }
            
            if let page = reviewOfPlaceParameter.page {
                parameters.updateValue(page, forKey: "page")
            }
            return parameters
        case .postPlaceReview(let postReviewParameter):
            guard let postReviewParameter = postReviewParameter as? [String: Any] else { return nil }
            return postReviewParameter
        case .scrap(let scrapParameter):
            guard let scrapParameter = scrapParameter as? ScrapParameter else { return nil }
            return [
                "scrap": scrapParameter.scrap
            ]
        case .like(let likeParameter, _, _):
            guard let likeParameter = likeParameter as? LikeParameter else { return nil }
            return [
                "like": likeParameter.like
            ]
        case .getCeleb(let celebParameter):
            var parameters: [String: Any] = [:]
            guard let searchParameter = celebParameter as? GetListParameter else { return nil }
            
            if let size = searchParameter.size {
                parameters.updateValue(size, forKey: "size")
            }
            
            if let search = searchParameter.search {
                parameters.updateValue(search, forKey: "search")
            }
            
            if let page = searchParameter.page {
                parameters.updateValue(page, forKey: "page")
            }
            return parameters
        case .getMedia(let mediaParameter):
            var parameters: [String: Any] = [:]
            guard let searchParameter = mediaParameter as? GetListParameter else { return nil }
            
            if let size = searchParameter.size {
                parameters.updateValue(size, forKey: "size")
            }
            
            if let search = searchParameter.search {
                parameters.updateValue(search, forKey: "search")
            }
            
            if let page = searchParameter.page {
                parameters.updateValue(page, forKey: "page")
            }
            return parameters
        case .search(let searchParameter):
            var parameters: [String: Any] = [:]
            guard let searchParameter = searchParameter as? SearchParameter else { return nil }
            
            if let search = searchParameter.search {
                parameters.updateValue(search, forKey: "search")
            }
            return parameters
        case .getCelebOfID: return nil
        case .getMediaOfID: return nil
        case .getReviewOfCeleb(let reviewParameter, _):
            var parameters: [String: Any] = [:]
            guard let reviewParameter = reviewParameter as? GetReviewParameter else { return nil }
            if let page = reviewParameter.page {
                parameters.updateValue(page, forKey: "page")
            }
            
            if let size = reviewParameter.size {
                parameters.updateValue(size, forKey: "size")
            }
            
            if let sort = reviewParameter.sort {
                parameters.updateValue(sort, forKey: "sort")
            }
            return parameters
        case .getReviewOfMedia(let reviewParameter, _):
            var parameters: [String: Any] = [:]
            guard let reviewParameter = reviewParameter as? GetReviewParameter else { return nil }
            if let page = reviewParameter.page {
                parameters.updateValue(page, forKey: "page")
            }
            
            if let size = reviewParameter.size {
                parameters.updateValue(size, forKey: "size")
            }
            
            if let sort = reviewParameter.sort {
                parameters.updateValue(sort, forKey: "sort")
            }
            return parameters
            
        case .changInfo(_, let body):
            var parameters: [String: Any] = [:]
            guard let changeInfoBodyParameter = body as? ChangeInfoBodyParameter else { return nil }
            
            parameters.updateValue(changeInfoBodyParameter.gender, forKey: "gender")
            parameters.updateValue(changeInfoBodyParameter.nickName, forKey: "nickName")
            parameters.updateValue(changeInfoBodyParameter.loginPw, forKey: "loginPw")
            parameters.updateValue(changeInfoBodyParameter.modifyLoginPw, forKey: "modifyLoginPw")
            parameters.updateValue(changeInfoBodyParameter.speech, forKey: "speech")
            return parameters
        case .getMyPhotoReview(let reviewParameter):
            var parameters: [String: Any] = [:]
            guard let reviewParameter = reviewParameter as? GetReviewParameter else { return nil }
            
            if let page = reviewParameter.page {
                parameters.updateValue(page, forKey: "page")
            }
            
            if let size = reviewParameter.size {
                parameters.updateValue(size, forKey: "size")
            }
            
            if let sort = reviewParameter.sort {
                parameters.updateValue(sort, forKey: "sort")
            }
    
            return parameters
        case .getMyScrap(let scrapParameter):
            var parameters: [String: Any] = [:]
            guard let scrapParameters = scrapParameter as? GetReviewParameter else { return nil }
            
            if let page = scrapParameters.page {
                parameters.updateValue(page, forKey: "page")
            }
            
            if let size = scrapParameters.size {
                parameters.updateValue(size, forKey: "size")
            }
            
            if let sort = scrapParameters.sort {
                parameters.updateValue(sort, forKey: "sort")
            }
    
            return parameters
        case .getMyInform:
            return nil
        }
    }
}
