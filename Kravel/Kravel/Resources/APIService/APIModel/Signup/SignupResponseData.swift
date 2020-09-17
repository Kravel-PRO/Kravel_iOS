//
//  SignupData.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/31.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct SignupResponse: Codable {
    let memberId: Int
    let loginEmail: String
    let loginPw: String?
    let nickName: String
    let gender: String
    let roleType: String
    let speech: String
    let createdDate: String
    let modifiedData: String
    let useAt: String?
}
