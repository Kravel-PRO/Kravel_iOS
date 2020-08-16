//
//  ViewController.swift
//  Kravel
//
//  Created by 윤동민 on 2020/06/03.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
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
        if isToggle { isToggle = false }
    }
    
    @IBAction func clickLogin(_ sender: Any) {
        isToggle = isToggle ? false : true
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        loginTextView.setBorderColor(of: textField)
    }
}

extension ViewController: LoginTextViewDelegate {
    func clickLoginButton(id: String, pw: String) {
        print(id, pw)
        guard let mainTabVC = UIStoryboard(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "MainTabVC") as? UITabBarController else { return }
        mainTabVC.modalPresentationStyle = .fullScreen
        self.present(mainTabVC, animated: true, completion: nil)
    }
}

