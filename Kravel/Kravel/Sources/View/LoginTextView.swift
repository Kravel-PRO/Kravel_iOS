//
//  LoginTextView.swift
//  Kravel
//
//  Created by 윤동민 on 2020/06/03.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

protocol LoginTextViewDelegate {
    func clickLoginButton(id: String, pw: String)
}

class LoginTextView: UIView {
    static let identifier = "LoginTextView"
    
    var textViewDelegate: UITextFieldDelegate? {
        didSet {
            if let delegate = textViewDelegate {
                emailTextField.delegate = delegate
                pwTextField.delegate = delegate
            }
        }
    }
    
    var delegate: LoginTextViewDelegate?
    
    @IBOutlet var marginViews: [UIView]! {
        didSet {
            marginViews.forEach { view in
                view.layer.borderColor = UIColor.veryLightPink.cgColor
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
    
    @IBAction func login(_ sender: Any) {
        delegate?.clickLoginButton(id: "ww", pw: "ww")
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
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
    
    func setBorderColor(of textField: UITextField) {
        let layerColor: UIColor = textField.text == "" ? .veryLightPink : .grapefruit
        if textField == emailTextField { marginViews[0].layer.borderColor = layerColor.cgColor }
        else { marginViews[1].layer.borderColor = layerColor.cgColor }
    }
    
    func clear() {
        emailTextField.text = ""
        pwTextField.text = ""
        self.endEditing(true)
        marginViews.forEach { view in
            view.layer.borderColor = UIColor.veryLightPink.cgColor
        }
    }
}
