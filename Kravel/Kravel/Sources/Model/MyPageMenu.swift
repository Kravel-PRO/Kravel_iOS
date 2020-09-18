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
//    case report = 3
    case logout = 3
    
    func getMenuLabel() -> String {
        switch self {
        case .editMyInform: return "내 정보 수정".localized
        case .editMyPW: return "비밀번호 수정".localized
        case .setLanguage: return "언어 설정".localized
//        case .report: return "제보하기".localized
        case .logout: return "로그아웃".localized
        }
    }
    
    func getImageName() -> String {
        switch self {
        case .editMyInform: return ImageKey.icModify
        case .editMyPW: return ImageKey.icPassword
        case .setLanguage: return ImageKey.icLanguage
//        case .report: return ImageKey.icReport
        case .logout: return ImageKey.icLogout
        }
    }
}
