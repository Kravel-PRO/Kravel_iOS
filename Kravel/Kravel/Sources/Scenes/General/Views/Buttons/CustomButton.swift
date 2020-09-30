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
        case languageViewStart
        case signupView
        case welcomeView
        case reportView
        case editPasswordView
        case logoutPopupView
        case galleryUploadPhotoView
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
                    layer.borderColor = UIColor.white.cgColor
                case .languageViewStart:
                    setTitleColor(.veryLightPink, for: .normal)
                    setTitleColor(.white, for: .highlighted)
                    layer.borderColor = UIColor.white.cgColor
                case .reportView:
                    setTitleColor(.veryLightPink, for: .normal)
                    setTitleColor(.white, for: .highlighted)
                    layer.borderColor = UIColor.white.cgColor
                case .editPasswordView:
                    setTitleColor(.veryLightPink, for: .normal)
                    setTitleColor(.white, for: .highlighted)
                    layer.borderColor = UIColor.white.cgColor
                case .logoutPopupView:
                    setTitleColor(.veryLightPink, for: .normal)
                    setTitleColor(.white, for: .highlighted)
                    layer.borderColor = UIColor.veryLightPink.cgColor
                case .galleryUploadPhotoView:
                    setTitleColor(.white, for: .normal)
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
                    self.backgroundColor = isHighlighted ? UIColor(red: 205/255, green: 52/255, blue: 52/255, alpha: 1.0) : .grapefruit
                case .welcomeView:
                    self.backgroundColor = isHighlighted ? UIColor(red: 205/255, green: 52/255, blue: 52/255, alpha: 1.0) : .grapefruit
                case .languageViewStart:
                    self.backgroundColor = isHighlighted ? UIColor(red: 205/255, green: 52/255, blue: 52/255, alpha: 1.0) : .grapefruit
                case .reportView:
                    self.backgroundColor = isHighlighted ? .grapefruit : UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
                case .editPasswordView:
                    self.backgroundColor = isHighlighted ? .grapefruit : UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
                case .logoutPopupView:
                    self.backgroundColor = isHighlighted ? .grapefruit : .white
                    layer.borderColor = isHighlighted ? UIColor.grapefruit.cgColor : UIColor.veryLightPink.cgColor
                case .galleryUploadPhotoView:
                    self.backgroundColor = isHighlighted ? UIColor(red: 205/255, green: 52/255, blue: 52/255, alpha: 1.0) : .grapefruit
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
