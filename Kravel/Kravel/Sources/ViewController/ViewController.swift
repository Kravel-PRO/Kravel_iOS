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
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginTextViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginTextView: LoginTextView!
    
    private var isToggle: Bool = false {
        didSet {
            if isToggle {
                signupButton.alpha = 0
                signinButton.alpha = 0
                backViewBottomConstraint.constant = loginTextView.frame.height - (loginTextView.frame.height/2)
                loginTextViewTopConstraint.constant = -loginTextView.frame.height/2
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            } else {
                backViewBottomConstraint.constant = 0
                loginTextViewTopConstraint.constant = 0
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
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

