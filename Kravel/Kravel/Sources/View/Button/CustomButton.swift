//
//  SignButton.swift
//  Kravel
//
//  Created by 윤동민 on 2020/06/03.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    enum LocationButton {
        case textView
        case initView
        case languageView(isSelected: Bool)
        case signupView
        case welcomeView
    }
    
    var locationButton: LocationButton? = nil {
        didSet {
            if let locationButton = self.locationButton {
                switch locationButton {
                case .initView:
                    setTitleColor(.white, for: .normal)
                    setTitleColor(.grapefruit, for: .highlighted)
                    layer.borderColor = UIColor.white.cgColor
                case .textView:
                    setTitleColor(.veryLightPink, for: .normal)
                    setTitleColor(.white, for: .highlighted)
                    layer.borderColor = UIColor.white.cgColor
                case .languageView:
                    setTitleColor(.veryLightPink, for: .normal)
                    layer.borderColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0).cgColor
                case .signupView:
                    setTitleColor(.veryLightPink, for: .normal)
                    setTitleColor(.white, for: .highlighted)
                    layer.borderColor = UIColor.white.cgColor
                case .welcomeView:
                    setTitleColor(.veryLightPink, for: .normal)
                    setTitleColor(.white, for: .highlighted)
                    layer.borderColor = UIColor.white.cgColor
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
                    self.backgroundColor = isHighlighted ? .grapefruit : UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
                case .languageView: break
                case .signupView:
                    self.backgroundColor = isHighlighted ? .grapefruit : UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
                case .welcomeView:
                    self.backgroundColor = isHighlighted ? .grapefruit : UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
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
        self.layer.borderWidth = 2
        self.layer.cornerRadius = self.frame.width / 11
    }
}
