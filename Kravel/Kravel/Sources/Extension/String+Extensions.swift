//
//  String+Extensions.swift
//  Kravel
//
//  Created by 윤동민 on 2020/06/09.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation

extension String {
    func isEmailFormat() -> Bool {
        let emailPattern: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let regex = try? NSRegularExpression(pattern: emailPattern, options: [])
        let matchNumber = regex?.numberOfMatches(in: self, options: [], range: NSRange(self.startIndex..., in: self))
        return matchNumber != 0
    }
}
