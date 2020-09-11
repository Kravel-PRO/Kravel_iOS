//
//  Category.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/14.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

enum KCategory: Int, CaseIterable {
    case celeb = 0
    case media = 1
    
    func getCategoryString() -> String {
        switch self {
        case .celeb: return "연예인 별".localized
        case .media: return "드라마/영화 별".localized
        }
    }
}
