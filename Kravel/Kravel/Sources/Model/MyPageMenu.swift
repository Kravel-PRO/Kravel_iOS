//
//  MyPageMenu.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/22.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

enum MyPageMenu: Int, CaseIterable {
    case editMyInform = 0
    case editMyPW = 1
    case setLanguage = 2
    case report = 3
    case logout = 4
    
    func getMenuLabel() -> String {
        switch self {
        case .editMyInform: return "내 정보 수정"
        case .editMyPW: return "비밀번호 수정"
        case .setLanguage: return "언어 설정"
        case .report: return "제보하기"
        case .logout: return "로그아웃"
        }
    }
    
    func getImageName() -> String {
        switch self {
        case .editMyInform: return "icModify"
        case .editMyPW: return "icPassword"
        case .setLanguage: return "icLang"
        case .report: return "icReport"
        case .logout: return "icLogout"
        }
    }
}
