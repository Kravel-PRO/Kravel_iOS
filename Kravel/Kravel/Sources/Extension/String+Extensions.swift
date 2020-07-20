//
//  String+Extensions.swift
//  Kravel
//
//  Created by 윤동민 on 2020/06/09.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

extension String {
    // MARK: - 포맷 확인
    func isEmailFormat() -> Bool {
        let emailPattern: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let regex = try? NSRegularExpression(pattern: emailPattern, options: [])
        let matchNumber = regex?.numberOfMatches(in: self, options: [], range: NSRange(self.startIndex..., in: self))
        return matchNumber != 0
    }
    
    // MARK: - Attribute 관련 메소드
    func makeAttributedText(_ attributes: [NSAttributedString.Key: Any] = [:],
                            of range: String? = nil) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        if let range = range { attributedString.addAttributes(attributes, range: (self as NSString).range(of: range)) }
        else { attributedString.addAttributes(attributes, range: (self as NSString).range(of: self)) }
        return attributedString
    }
}
