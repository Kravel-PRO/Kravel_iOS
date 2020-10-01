//
//  NetworkHandler.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/30.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit
import Alamofire

class NetworkHandler {
    static let shared = NetworkHandler()
    
    func requestAPI<P: ParameterAble>(apiCategory: APICategory<P>, completion: @escaping (NetworkResult<Codable>) -> Void) {
        let apiURL = apiCategory.makeURL()
        let headers = apiCategory.makeHeader()
        let parameters = apiCategory.makeParameter()
        
        switch apiCategory {
        case .signup: requestSignup(apiURL, headers, parameters, completion)
        case .signin: requestSignin(apiURL, headers, parameters, completion)
        case .guest: requestGuestToken(apiURL, headers, parameters, completion)
        case .searchPlaceKakao: requestSearchPlace(apiURL, headers, parameters, completion)
        case .getPlace: requestGetPlace(apiURL, headers, parameters, completion)
        case .getSimplePlace: requestSimplePlace(apiURL, headers, parameters, completion)
        case .getPlaceOfID: requestGetPlaceOfID(apiURL, headers, parameters, completion)
        case .getReview: requestGetReview(apiURL, headers, parameters, completion)
        case .getPlaceReview: requestGetReviewOfPlace(apiURL, headers, parameters, completion)
        case .postPlaceReview: requestPostReviewOfPlace(apiURL, headers, parameters, completion)
        case .deletePlaceReview: requestDeleteReview(apiURL, headers, parameters, completion)
        case .scrap: requestScrap(apiURL, headers, parameters, completion)
        case .like: requestLike(apiURL, headers, parameters, completion)
        case .getCeleb: requestCeleb(apiURL, headers, parameters, completion)
        case .getMedia: requestMedia(apiURL, headers, parameters, completion)
        case .search: requestSearch(apiURL, headers, parameters, completion)
        case .getCelebOfID: requestCelebOfID(apiURL, headers, parameters, completion)
        case .getMediaOfID: requestMediaOfID(apiURL, headers, parameters, completion)
        case .getReviewOfCeleb: requestGetReview(apiURL, headers, parameters, completion)
        case .getReviewOfMedia: requestGetReview(apiURL, headers, parameters, completion)
        case .changInfo: requestChangeInfo(apiURL, headers, parameters, completion)
        case .getMyPhotoReview: requestMyPhotoReview(apiURL, headers, parameters, completion)
        case .getMyScrap: requestMyScrap(apiURL, headers, parameters, completion)
        case .getMyInform: requestMyInform(apiURL, headers, parameters, completion)
        }
    }
    
    private func requestSignup(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: APIResponseData<APICantSortableDataResult<SignupResponse>, APIError>.self) { response in
                switch response.result {
                case .success(let signupResponse):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 {
                        completion(.success(signupResponse.data?.result)) }
                    else { completion(.requestErr(signupResponse.error?.errorMessage)) }
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
    
    private func requestGuestToken(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseData { response in
                switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 {
                        guard let token = response.response?.headers["Authorization"] else { return }
                        completion(.success(token))
                    } else {
                        completion(.serverErr)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.networkFail)
                }
            }
    }
    
    private func requestSearchPlace(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate(statusCode: 200...503)
            .responseDecodable(of: SearchPlaceResponseData.self) { response in
                switch response.result {
                case .success(let placeResult):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 { completion(.success(placeResult)) }
                    else if statusCode == 400 { completion(.requestErr("실패")) }
                    else { completion(.serverErr) }
                case .failure(let error):
                    print(error)
                    completion(.networkFail)
                }
        }
    }
    
    private func requestGetPlace(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: APIResponseData<APIDataResult<PlaceContentInform>, APIError>.self) { response in
                switch response.result {
                case .success(let getPlaceResponseData):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 {
                        guard let getPlaceResult = getPlaceResponseData.data?.result else {
                            completion(.serverErr)
                            return
                        }
                        completion(.success(getPlaceResult))
                    } else {
                        print(getPlaceResponseData.error ?? "Error")
                        completion(.requestErr("실패"))
                    }
                case .failure(let error):
                    print(error)
                    completion(.networkFail)
                }
        }
    }
    
    private func requestSimplePlace(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: APIResponseData<APICantSortableDataResult<[SimplePlace]>, APIError>.self) { response in
                switch response.result {
                case .success(let getSimplePlaceResponseData):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 {
                        guard let getPlaceResult = getSimplePlaceResponseData.data?.result else {
                            completion(.serverErr)
                            return
                        }
                        completion(.success(getPlaceResult))
                    } else {
                        completion(.requestErr("실패"))
                    }
                case .failure(let error):
                    print(error)
                    completion(.networkFail)
                }
        }
    }
    
    private func requestGetPlaceOfID(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: APIResponseData<APICantSortableDataResult<PlaceDetailInform>, APIError>.self) { response in
                switch response.result {
                case .success(let getPlaceResponseData):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 {
                        guard let getPlaceResult = getPlaceResponseData.data?.result else {
                            completion(.serverErr)
                            return
                        }
                        completion(.success(getPlaceResult))
                    } else {
                        completion(.serverErr)
                    }
                case .failure(let error):
                    print(error)
                    completion(.networkFail)
                }
        }
    }
    
    private func requestGetReview(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: APIResponseData<APIDataResult<ReviewInform>, APIError>.self) { response in
                switch response.result {
                case .success(let getReviewResponseData):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 {
                        guard let getReviewResult = getReviewResponseData.data?.result else { return }
                        completion(.success(getReviewResult))
                    } else {
                        completion(.requestErr("실패"))
                    }
                case .failure(let error):
                    print(error)
                    completion(.networkFail)
                }
        }
    }
    
    private func requestGetReviewOfPlace(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: APIResponseData<APIDataResult<ReviewInform>, APIError>.self) { response in
                switch response.result {
                case .success(let getReviewResponseData):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 {
                        guard let getReviewResult = getReviewResponseData.data?.result else { return }
                        completion(.success(getReviewResult))
                    } else {
                        completion(.requestErr("실패"))
                    }
                case .failure(let error):
                    print(error)
                    completion(.networkFail)
                }
        }
    }
    
    private func requestPostReviewOfPlace(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.upload(multipartFormData: { multipartFormData in
            guard let imgDic = parameters
                , let imgData = (imgDic[ImageDictionaryKey.img.rawValue] as? UIImage)?.jpegData(compressionQuality: 0.5)
                , let fileName = imgDic[ImageDictionaryKey.fileName.rawValue] as? String
                else { return }
            
            multipartFormData.append(imgData, withName: "file",
                                     fileName: fileName,
                                     mimeType: "image/jpeg") },
            to: url,
            usingThreshold: UInt64(),
            method: .post,
            headers: headers).responseDecodable(of: APIResponseData<APICantSortableDataResult<Int>, APIError>.self) { response in
                switch response.result {
                case .success(let postReviewResult):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 { completion(.success(statusCode)) }
                    else { completion(.serverErr) }
                case .failure(let error):
                    print(error)
                    completion(.networkFail)
                }
            }
    }
    
    private func requestDeleteReview(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: APIResponseData<APICantSortableDataResult<Int>, APIError>.self) {
                response in
                switch response.result {
                case .success(let deleteResult):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 { completion(.success(deleteResult.data?.result)) }
                    else { completion(.serverErr) }
                case .failure(let error):
                    print(error)
                    completion(.networkFail)
                }
            }
    }
     
    private func requestScrap(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: APIResponseData<APICantSortableDataResult<Int>, APIError>.self) { response in
                switch response.result {
                case .success(let scrapResult):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 {
                        completion(.success(scrapResult.data?.result))
                    } else {
                        completion(.requestErr(scrapResult.error))
                    }
                case .failure(let error):
                    print(error)
                    completion(.networkFail)
                }
        }
    }
    
    private func requestLike(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: APIResponseData<APICantSortableDataResult<Int>, APIError>.self) { response in
                switch response.result {
                case .success(let likeResult):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 {
                        completion(.success(likeResult.data?.result))
                    } else {
                        completion(.requestErr(likeResult.error))
                    }
                case .failure(let error):
                    print(error)
                    completion(.networkFail)
                }
        }
    }
    
    private func requestCeleb(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: APIResponseData<APIDataResult<CelebrityDTO>, APIError>.self) { response in
                switch response.result {
                case .success(let celebResult):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 {
                        completion(.success(celebResult.data?.result?.content))
                    } else {
                        completion(.serverErr)
                    }
                case .failure(let error):
                    print(error)
                    completion(.networkFail)
                }
        }
    }
    
    private func requestMedia(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: APIResponseData<APIDataResult<MediaDTO>, APIError>.self) { response in
                switch response.result {
                case .success(let mediaResult):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 {
                        completion(.success(mediaResult.data?.result?.content))
                    } else {
                        completion(.serverErr)
                    }
                case .failure(let error):
                    print(error)
                    completion(.networkFail)
                }
        }
    }
    
    private func requestSearch(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: APIResponseData<APICantSortableDataResult<SearchResultDTO>, APIError>.self) { response in
                switch response.result {
                case .success(let searchResult):
                    guard let statusCode = response.response?.statusCode else { return }
                    print(statusCode)
                    if statusCode == 200 {
                        completion(.success(searchResult.data?.result))
                    } else {
                        completion(.serverErr)
                    }
                case .failure(let error):
                    print(error)
                    completion(.networkFail)
                }
        }
    }
    
    private func requestCelebOfID(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: APIResponseData<APICantSortableDataResult<CelebrityDetailDTO>, APIError>.self) { response in
                switch response.result {
                case .success(let detailCelebResult):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 {
                        completion(.success(detailCelebResult.data?.result))
                    } else {
                        completion(.serverErr)
                    }
                case .failure(let error):
                    print(error)
                    completion(.networkFail)
                }
        }
    }
    
    private func requestMediaOfID(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: APIResponseData<APICantSortableDataResult<MediaDetailDTO>, APIError>.self) { response in
                switch response.result {
                case .success(let detailMediaResult):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 {
                        completion(.success(detailMediaResult.data?.result))
                    }
                case .failure(let error):
                    print(error)
                    completion(.networkFail)
                }
        }
    }
    
    private func requestChangeInfo(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: APIResponseData<APICantSortableDataResult<ChangeInfoResponseData>, APIError>.self) { response in
                switch response.result {
                case .success(let successData):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 {
                        guard let token = response.response?.headers["Authorization"] else { return }
                        UserDefaults.standard.setValue(token, forKey: UserDefaultKey.token)
                        completion(.success(successData.data?.result))
                    } else {
                        completion(.serverErr) }
                case .failure(let error):
                    print(error)
                    completion(.networkFail)
                }
        }
    }
    
    private func requestMyPhotoReview(_ url: String, _ headers: HTTPHeaders?, _ paramters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .get, parameters: paramters, encoding: URLEncoding.queryString, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: APIResponseData<APIDataResult<ReviewInform>, APIError>.self) { response in
                switch response.result {
                case .success(let reviewData):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 { completion(.success(reviewData.data?.result)) }
                    else { completion(.serverErr) }
                case .failure(let error):
                    print(error)
                    completion(.networkFail)
                }
        }
    }
    
    private func requestMyScrap(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: APIResponseData<APIDataResult<PlaceContentInform>, APIError>.self) { response in
                switch response.result {
                case .success(let placeResponse):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 { completion(.success(placeResponse.data?.result)) }
                    else { completion(.serverErr) }
                case .failure(let error):
                    print(error)
                    completion(.networkFail)
                }
        }
    }
    
    private func requestMyInform(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
        guard let url = try? url.asURL() else { return }
        
        AF.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: APIResponseData<APICantSortableDataResult<ChangeInfoResponseData>, APIError>.self) { response in
                switch response.result {
                case .success(let myInformResponse):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 { completion(.success(myInformResponse.data?.result)) }
                    else { completion(.serverErr) }
                case .failure(let error):
                    print(error)
                    completion(.networkFail)
                }
            }
    }
}
