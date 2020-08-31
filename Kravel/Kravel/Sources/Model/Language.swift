//
//  Language.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/16.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

enum Language {
    case korean
    case english
    
    func getLanguage() -> String {
        switch self {
        case .korean: return "KOR"
        case .english: return "ENG"
        }
    }
}
