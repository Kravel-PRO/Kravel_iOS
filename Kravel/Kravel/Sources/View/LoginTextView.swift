//
//  LoginTextView.swift
//  Kravel
//
//  Created by 윤동민 on 2020/06/03.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class LoginTextView: UIView {
    static let identifier = "LoginTextView"
    
    @IBOutlet var marginViews: [UIView]! {
        didSet {
            marginViews.forEach { view in
                view.layer.borderColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0).cgColor
                view.layer.borderWidth = 1
                view.layer.cornerRadius = view.frame.width / 15
            }
        }
    }
    
    @IBOutlet weak var loginButton: UIButton! {
        willSet {
            guard let loginButton = newValue as? CustomButton else { return }
            loginButton.locationButton = .textView
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        setCorner()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
        setCorner()
    }
    
    private func initView() {
        guard let view = Bundle.main.loadNibNamed(LoginTextView.identifier, owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    private func setCorner() {
        layer.cornerRadius = bounds.width / 20
        layer.masksToBounds = true
    }
}
