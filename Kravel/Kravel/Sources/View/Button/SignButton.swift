//
//  SignButton.swift
//  Kravel
//
//  Created by 윤동민 on 2020/06/03.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class SignButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? .white : .clear
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setBorder()
        setTitle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setBorder()
        setTitle()
    }

    private func setBorder() {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = self.frame.width / 11
    }
    
    private func setTitle() {
        setTitleColor(UIColor(red: 255/255, green: 103/255, blue: 97/255, alpha: 1.0), for: .highlighted)
        setTitleColor(.white, for: .normal)
    }
}
