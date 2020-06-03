//
//  SignButton.swift
//  Kravel
//
//  Created by 윤동민 on 2020/06/03.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class SignButton: UIButton {
    enum LocationButton {
        case textView
        case initView
    }
    
    var locationButton: LocationButton? = nil {
        didSet {
            if let locationButton = self.locationButton {
                switch locationButton {
                case .initView:
                    setTitleColor(.white, for: .normal)
                    setTitleColor(UIColor(red: 255/255, green: 103/255, blue: 97/255, alpha: 1.0), for: .highlighted)
                case .textView:
                    setTitleColor(UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0), for: .normal)
                    setTitleColor(.white, for: .highlighted)
                }
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if let locationButton = self.locationButton {
                switch locationButton {
                case .initView:
                    self.backgroundColor = isHighlighted ? .white : .clear
                case .textView:
                    self.backgroundColor = isHighlighted ? UIColor(red: 255/255, green: 103/255, blue: 97/255, alpha: 1.0) : UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setBorder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setBorder()
    }

    private func setBorder() {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = self.frame.width / 11
    }
}
