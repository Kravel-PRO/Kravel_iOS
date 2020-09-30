//
//  ToastView.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/27.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class ToastView: UIView {
    // MARK: - 토스트 Label
    var toastLabel: UILabel = {
        let toastLabel = UILabel()
        toastLabel.font = UIFont.systemFont(ofSize: 12)
        toastLabel.numberOfLines = 0
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        return toastLabel
    }()
    
    // MARK: - 토스트 화면 메세지 설정
    var toastMessage: String? {
        didSet {
            toastLabel.text = toastMessage
            toastLabel.sizeToFit()
            
            let cornerRadius = toastLabel.intrinsicContentSize.width + 8 * 2
            self.layer.cornerRadius = cornerRadius / 9.5
        }
    }
    
    // MARK: - 보여주기
    func show() {
        self.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.hide()
        }
    }
    
    // MARK: - 숨기기
    func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { isCompletion in
            if isCompletion {
                self.isHidden = true
            }
        })
    }

    // MARK: - UIView Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(toastLabel)
        setLayout()
        self.backgroundColor = UIColor(red: 104/255, green: 100/255, blue: 100/255, alpha: 0.84)
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(toastLabel)
        setLayout()
        self.backgroundColor = UIColor(red: 104/255, green: 100/255, blue: 100/255, alpha: 0.84)
        self.clipsToBounds = true
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            toastLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            toastLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            toastLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            toastLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25)
        ])
    }
}
