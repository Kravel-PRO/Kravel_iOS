//
//  UIView+Extensions.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/28.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

extension UIView {
    func makeShadow(color: UIColor, blur: CGFloat = 3, x: CGFloat = 0, y: CGFloat = 0) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = blur
        self.layer.shadowOffset = CGSize(width: x, height: y)
    }
}
