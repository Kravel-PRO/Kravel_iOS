//
//  SignupVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/06/07.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {
    @IBOutlet weak var signupScrollView: UIScrollView! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTouched))
            gesture.numberOfTouchesRequired = 1
            signupScrollView.addGestureRecognizer(gesture)
        }
    }
    
    @objc func viewTouched() {
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "Kravel과 함께\n색다른\n여행을 떠나볼까요?"
            titleLabel.textColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
            titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        }
    }
    
    @IBOutlet weak var signupButton: UIButton! {
        didSet {
            guard let customButton = signupButton as? CustomButton else { return }
            customButton.locationButton = .signupView
        }
    }
    
    @IBOutlet var textFields: [UITextField]! {
        didSet {
            textFields.forEach { textField in
                textField.delegate = self
            }
        }
    }
    
    @IBOutlet var marginViews: [UIView]! {
        didSet {
            marginViews.forEach { view in
                view.layer.borderColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0).cgColor
                view.layer.borderWidth = 1
                view.layer.cornerRadius = view.frame.width / 15
            }
        }
    }
    
    @IBOutlet var validLabels: [UILabel]! {
        didSet {
            validLabels.forEach { label in
                label.alpha = 0
                label.isHidden = true
            }
        }
    }
    
    @IBOutlet var sexButtons: [SexButton]! {
        didSet {
            sexButtons[0].sex = .man
            sexButtons[1].sex = .woman
            sexButtons.forEach { button in
                button.delegate = self
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let size = titleLabel.sizeThatFits(CGSize(width: self.view.frame.width, height: CGFloat.greatestFiniteMagnitude))
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
    
    private func setNav() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1.0)
        self.navigationController?.navigationBar.topItem?.title = ""
        setTransparentNav()
    }
    
    @IBAction func clickSignup(_ sender: Any) {
    }
}

extension SignupVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let layerColor: UIColor = text != "" ? UIColor(red: 253/255, green: 9/255, blue: 9/255, alpha: 1.0) : .veryLightPink
        
        if textField == textFields[0] {
            // ID TextField인 경우
            marginViews[0].layer.borderColor = layerColor.cgColor
            if text.isEmailFormat() || text == "" { setValid(marginView: marginViews[0], validLabel: validLabels[0]) }
            else { setInvalid(marginView: marginViews[0], validLabel: validLabels[0]) }
        } else if textField == textFields[1] {
            // PW TextField인 경우
            marginViews[1].layer.borderColor = layerColor.cgColor
            if text.count >= 6 || text == "" { setValid(marginView: marginViews[1], validLabel: validLabels[1]) }
            else { setInvalid(marginView: marginViews[1], validLabel: validLabels[1]) }
            
            if text == textFields[2].text && text != "" || textFields[2].text == "" { setValid(marginView: marginViews[2], validLabel: validLabels[2]) }
            else { setInvalid(marginView: marginViews[2], validLabel: validLabels[2]) }
        } else if textField == textFields[2] {
            marginViews[2].layer.borderColor = layerColor.cgColor
            if textFields[1].text == text || text == "" { setValid(marginView: marginViews[2], validLabel: validLabels[2]) }
            else { setInvalid(marginView: marginViews[2], validLabel: validLabels[2]) }
        } else {
            marginViews[3].layer.borderColor = layerColor.cgColor
        }
    }
    
    private func setValid(marginView: UIView, validLabel: UILabel) {
        marginView.backgroundColor = .white
        UIView.animate(withDuration: 0.3, animations: {
            validLabel.alpha = 0
        }, completion: { isCompletion in
            validLabel.isHidden = true
        })
    }
    
    private func setInvalid(marginView: UIView, validLabel: UILabel) {
        marginView.backgroundColor = UIColor.grapefruit.withAlphaComponent(0.15)
        validLabel.isHidden = false
        UIView.animate(withDuration: 0.3) {
            validLabel.alpha = 1.0
        }
    }
}

extension SignupVC {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension SignupVC: XibButtonDelegate {
    func clickButton(of sex: Sex) {
        switch sex {
        case .man:
            sexButtons[0].setSelectedState(by: true)
            sexButtons[1].setSelectedState(by: false)
        case .woman:
            sexButtons[0].setSelectedState(by: false)
            sexButtons[1].setSelectedState(by: true)
        }
    }
}
