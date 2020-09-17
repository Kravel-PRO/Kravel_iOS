//
//  ChangeInfoResponseData.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/15.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

struct ChangeInfoResponseData: Codable {
    let memberId: Int
    let loginEmail: String?
    let loginPw: String?
    let nickName: String?
    let gender: String?
    let roleType: String?
    let speech: String?
    let createdDate: String
    let modifiedDate: String
    let useAt: String?
}
