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
    
    var textViewDelegate: UITextFieldDelegate? {
        didSet {
            if let delegate = textViewDelegate {
                emailTextField.delegate = delegate
                pwTextField.delegate = delegate
            }
        }
    }
    
    var delegate: LoginTextViewDelegate?
    
    // MARK: - TextField의 Margin View들 설정
    @IBOutlet var marginViews: [UIView]!
    
    func setMarginViewsLayout() {
        marginViews.forEach { view in
            view.layer.borderColor = UIColor.veryLightPink.cgColor
            view.layer.borderWidth = 1
            view.layer.cornerRadius = view.frame.width / 15
        }
    }
    
    // MARK: - 각 설명 Label
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var pwLabel: UILabel!
    
    // MARK: - 로그인 버튼 관련
    @IBOutlet weak var loginButton: UIButton! {
        willSet {
            guard let loginButton = newValue as? CustomButton else { return }
            loginButton.locationButton = .textView
        }
    }
    
    @IBAction func login(_ sender: Any) {
        guard let emailText = emailTextField.text,
            let pwText = pwTextField.text else { return }
        delegate?.clickLoginButton(id: emailText, pw: pwText)
    }
    
    // MARK: - TextField 변수
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    // MARK: - UIView Override 함수
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        setCorner()
        setTextByLanguage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
        setCorner()
        setTextByLanguage()
    }
    
    private func initView() {
        guard let view = Bundle.main.loadNibNamed(LoginTextView.identifier, owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    private func setTextByLanguage() {
        emailLabel.text = "이메일 계정".localized
        pwLabel.text = "비밀번호".localized
        emailTextField.placeholder = "이메일을 입력해주세요.".localized
        pwTextField.placeholder = "비밀번호를 입력해주세요.".localized
        loginButton.setTitle("로그인 하기".localized, for: .normal)
    }
    
    private func setCorner() {
        layer.cornerRadius = bounds.width / 20
        layer.masksToBounds = true
    }
    
    // TextField안의 입력 상태에 따라 Border Color 지정
    func setBorderColor(of textField: UITextField) {
        let layerColor: UIColor = textField.text == "" ? .veryLightPink : .grapefruit
        if textField == emailTextField { marginViews[0].layer.borderColor = layerColor.cgColor }
        else { marginViews[1].layer.borderColor = layerColor.cgColor }
    }
    
    // TextField 내용 초기화
    func clear() {
        emailTextField.text = ""
        pwTextField.text = ""
        marginViews.forEach { view in
            view.layer.borderColor = UIColor.veryLightPink.cgColor
        }
    }
    
    func isKeyboardShow() -> Bool {
        if emailTextField.isFirstResponder || pwTextField.isFirstResponder { return true }
        else { return false }
    }
}
