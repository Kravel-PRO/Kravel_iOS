//
//  Category.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/14.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

enum KCategory: Int, CaseIterable {
    case talent = 0
    case move = 1
    
    func getCategoryString() -> String {
        switch self {
        case .talent: return "연예인 별"
        case .move: return "드라마/영화 별"
        }
    }
}
