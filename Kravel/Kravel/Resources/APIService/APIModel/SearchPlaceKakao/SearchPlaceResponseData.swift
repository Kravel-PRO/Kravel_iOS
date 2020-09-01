//
//  SearchPlaceResponseData.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/02.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct SearchPlaceResponseData: Codable {
    let meta: Meta
    let documents: [DetailPlaceInform]
}

struct Meta: Codable {
    // 검색어에 검색된 문서 수
    let total_count: Int
    
    // total_count 중 노출 가능 문서 수, 최대 45
    let pageable_count: Int
    
    // 현재 페이지가 마지막 페이지인지 여부
    // 값이 false면 page를 증가시켜 다음 페이지를 요청할 수 있음
    let is_end: Bool
    
    // 질의어의 지역 및 키워드 분석 정보
    let same_name: RegionInfo
}

struct RegionInfo: Codable {
    // 질의어에서 인식된 지역의 리스트
    // ex) '중앙로 맛집' 에서 중앙로에 해당하는 지역 리스트
    let region: [String]
    
    // 질의어에서 지역 정보를 제외한 키워드
    // ex) '중앙로 맛집' 에서 '맛집'
    let keyword: String
    
    // 인식된 지역 리스트 중, 현재 검색에 사용된 지역 정보
    let selected_region: String
}

struct DetailPlaceInform: Codable {
    let id: String
    let place_name: String
    let category_name: String
    let category_group_code: String
    let category_group_name: String
    let phone: String
    let address_name: String
    let road_address_name: String
    let x: String
    let y: String
    let place_url: String
    let distance: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case place_name
        case category_name
        case category_group_code
        case category_group_name
        case phone
        case address_name
        case road_address_name
        case x
        case y
        case place_url
        case distance
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? values.decode(String.self, forKey: .id)) ?? ""
        place_name = (try? values.decode(String.self, forKey: .place_name)) ?? ""
        category_name = (try? values.decode(String.self, forKey: .category_name)) ?? ""
        category_group_code = (try? values.decode(String.self, forKey: .category_group_code)) ?? ""
        category_group_name = (try? values.decode(String.self, forKey: .category_group_name)) ?? ""
        phone = (try? values.decode(String.self, forKey: .phone)) ?? ""
        address_name = (try? values.decode(String.self, forKey: .address_name)) ?? ""
        road_address_name = (try? values.decode(String.self, forKey: .road_address_name)) ?? ""
        x = (try? values.decode(String.self, forKey: .x)) ?? ""
        y = (try? values.decode(String.self, forKey: .y)) ?? ""
        place_url = (try? values.decode(String.self, forKey: .place_url)) ?? ""
        distance = (try? values.decode(String.self, forKey: .distance)) ?? nil
    }
}
