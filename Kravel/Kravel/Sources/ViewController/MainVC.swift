//
//  ViewController.swift
//  Kravel
//
//  Created by 윤동민 on 2020/06/03.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    @IBOutlet weak var signinButton: UIButton! {
        willSet {
            guard let signinButton = newValue as? CustomButton else { return }
            signinButton.locationButton = .initView
        }
    }
    
    @IBOutlet weak var signupButton: UIButton! {
        willSet {
            guard let signupButton = newValue as? CustomButton else { return }
            signupButton.locationButton = .initView
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10
            let attributedString = NSMutableAttributedString(string: "오늘도\nKravel과 함께\n여행을 떠나볼까요?", attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 24), .paragraphStyle: paragraphStyle])
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: ("오늘도\nKravel과 함께\n여행을 떠나볼까요?" as NSString).range(of: "오늘도"))
            titleLabel.attributedText = attributedString
            titleLabel.alpha = 0
        }
    }
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginTextViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginTextView: LoginTextView! {
        didSet {
            loginTextView.textViewDelegate = self
            loginTextView.delegate = self
        }
    }
    
    private var isToggle: Bool = false {
        didSet {
            if isToggle {
                signupButton.alpha = 0
                signinButton.alpha = 0
                titleLabel.transform = CGAffineTransform(translationX: 0, y: 50)
                backViewBottomConstraint.constant = loginTextView.frame.height - (loginTextView.frame.height/2)
                loginTextViewTopConstraint.constant = -loginTextView.frame.height/2
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    self.titleLabel.alpha = 1
                    self.titleLabel.transform = .identity
                    self.view.layoutIfNeeded()
                }, completion: nil)
            } else {
                backViewBottomConstraint.constant = 0
                loginTextViewTopConstraint.constant = 0
                self.view.endEditing(true)
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    self.titleLabel.alpha = 0
                    self.view.layoutIfNeeded()
                }, completion: { isCompletion in
                    self.loginTextView.clear()
                })
                
                signinButton.transform = CGAffineTransform(translationX: 0, y: -30)
                signupButton.transform = CGAffineTransform(translationX: 0, y: -30)
                UIView.animate(withDuration: 0.3) {
                    self.signinButton.transform = .identity
                    self.signupButton.transform = .identity
                    self.signinButton.alpha = 1
                    self.signupButton.alpha = 1
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addGesture()
        addKeyboardObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapView))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapView() {
        // Toggle이 되어 있을 때, Keyboard가 나와 있는 경우
        if isToggle && loginTextView.isKeyboardShow() {
            self.view.endEditing(true)
            return
        }
        
        if isToggle { isToggle = false }
    }
    
    @IBAction func clickLogin(_ sender: Any) {
        isToggle = isToggle ? false : true
    }
}

extension MainVC: UITextFieldDelegate {
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(downKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(upKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // KeyBoard가 내려갈 때, 호출
    @objc func downKeyboard(_ notification: NSNotification) {
        if let keyboardDuration: NSNumber = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber {
            UIView.animate(withDuration: TimeInterval(truncating: keyboardDuration)) {
                self.loginTextView.transform = .identity
            }
        }
    }
    
    // Keyboard가 올라올 때, 호출
    @objc func upKeyboard(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let keyboardDuraction: NSNumber = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            print(keyboardDuraction)
            UIView.animate(withDuration: TimeInterval(truncating: keyboardDuraction)) {
                self.loginTextView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight+20)
            }
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        loginTextView.setBorderColor(of: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension MainVC: LoginTextViewDelegate {
    func clickLoginButton(id: String, pw: String) {
        guard let mainTabVC = UIStoryboard(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "MainTabVC") as? UITabBarController else { return }
        mainTabVC.modalPresentationStyle = .fullScreen
        self.present(mainTabVC, animated: true, completion: nil)
    }
}

