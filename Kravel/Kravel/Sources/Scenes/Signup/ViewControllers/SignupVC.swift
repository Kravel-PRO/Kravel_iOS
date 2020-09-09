//
//  SignupVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/06/07.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {
    static let identifier = "SignupVC"
    
    // MARK: - 모든 필요사항 입력한 경우 5로 됨
    var enables: [Bool] = [false, false, false, false, false]
    var gender: String = ""
    
    // MARK: - 메인 ScrollView 설정
    @IBOutlet weak var signupScrollView: UIScrollView! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTouched))
            gesture.numberOfTouchesRequired = 1
            signupScrollView.addGestureRecognizer(gesture)
            signupScrollView.delaysContentTouches = false
        }
    }
    
    @objc func viewTouched() {
        self.view.endEditing(true)
    }
    
    // MARK: - 환영 Label 설정
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
            titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        }
    }
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var pwLabel: UILabel!
    @IBOutlet weak var pwConfirmLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    // MARK: - 회원가입 버튼 설정
    @IBOutlet weak var signupButton: CustomButton! {
        didSet {
            signupButton.locationButton = .signupView
            signupButton.isUserInteractionEnabled = false
        }
    }
    
    // 회원가입 API 요청
    @IBAction func signup(_ sender: Any) {
        guard let loginEmail = textFields[0].text, let loginPw = textFields[1].text,
            let nickName = textFields[3].text else { return }
        
        guard let selectedLanguage = UserDefaults.standard.object(forKey: "Language") as? String else { return }
        
        let signupParameter = SignupParmeter(loginEmail: loginEmail, loginPw: loginPw, nickName: nickName, gender: gender, speech: selectedLanguage)
        NetworkHandler.shared.requestAPI(apiCategory: .signup(signupParameter)) { result in
            switch result {
            // 데이터 통신 Success
            case .success(let userIdx):
                print(userIdx)
                guard let welcomeVC = UIStoryboard(name: "Welcome", bundle: nil).instantiateViewController(withIdentifier: WelcomeVC.identifier) as? WelcomeVC else { return }
                welcomeVC.modalPresentationStyle = .fullScreen
                self.present(welcomeVC, animated: true, completion: nil)
                
            // 사용자 실수 Error
            case .requestErr(let error):
                print(error)
                let alertVC = UIAlertController(title: "이미 존재하는 계정입니다.", message: "다른 계정으로 만들어주세요", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alertVC.addAction(action)
                self.present(alertVC, animated: true, completion: nil)
                
            // 서버 연결 실패 Error
            case .serverErr:
                print("serverError")
                
            // 네트워크 연결 실패 Error
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
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
    
    // MARK: - UIViewController viewDidLoad Override 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setByLanguage()
    }
    
    private func setByLanguage() {
        titleLabel.text = "Kravel과 함께\n색다른\n여행을 떠나볼까요?".localized
        emailLabel.text = "이메일 계정".localized
        textFields[0].placeholder = "이메일을 입력해주세요.".localized
        pwLabel.text = "비밀번호".localized
        textFields[1].placeholder = "비밀번호를 입력해주세요.".localized
        pwConfirmLabel.text = "비밀번호 확인".localized
        textFields[2].placeholder = "다시 한 번 비밀번호를 입력해주세요.".localized
        nicknameLabel.text = "닉네임".localized
        textFields[3].placeholder = "사용할 닉네임을 7자 이하로 적어주세요.".localized
        genderLabel.text = "성별".localized
        
        validLabels[0].text = "이메일 형식이 옳지 않습니다.".localized
        validLabels[1].text = "6자리 이상 입력해주세요.".localized
        validLabels[2].text = "비밀번호가 같지 않습니다.".localized
        validLabels[3].text = "7자 이하로 입력해주세요.".localized
        
        signupButton.setTitle("회원가입 하기".localized, for: .normal)
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
    
}

extension SignupVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let layerColor: UIColor = text != "" ? UIColor(red: 253/255, green: 9/255, blue: 9/255, alpha: 1.0) : .veryLightPink
        
        if textField == textFields[0] {
            // ID TextField인 경우
            marginViews[0].layer.borderColor = layerColor.cgColor
            if text.isEmailFormat() || text == "" {
                setValid(marginView: marginViews[0], validLabel: validLabels[0])
                if text == "" { enables[0] = false }
                else { enables[0] = true }
            } else {
                setInvalid(marginView: marginViews[0], validLabel: validLabels[0])
                enables[0] = false
            }
        } else if textField == textFields[1] {
            // PW TextField인 경우
            marginViews[1].layer.borderColor = layerColor.cgColor
            if text.count >= 6 || text == "" {
                setValid(marginView: marginViews[1], validLabel: validLabels[1])
                if text == "" { enables[1] = false }
                else { enables[1] = true }
            } else {
                setInvalid(marginView: marginViews[1], validLabel: validLabels[1])
                enables[1] = false
            }
            
            if text == textFields[2].text && text != "" || textFields[2].text == "" {
                setValid(marginView: marginViews[2], validLabel: validLabels[2])
                if textFields[2].text == "" { enables[2] = false }
                else { enables[2] = true }
            } else {
                setInvalid(marginView: marginViews[2], validLabel: validLabels[2])
                enables[2] = false
            }
        } else if textField == textFields[2] {
            marginViews[2].layer.borderColor = layerColor.cgColor
            if textFields[1].text == text || text == "" {
                setValid(marginView: marginViews[2], validLabel: validLabels[2])
                if text == "" { enables[2] = false }
                else { enables[2] = true }
            } else {
                setInvalid(marginView: marginViews[2], validLabel: validLabels[2])
                enables[2] = false
            }
        } else {
            marginViews[3].layer.borderColor = layerColor.cgColor
            if text.count <= 7 || text == "" {
                setValid(marginView: marginViews[3], validLabel: validLabels[3])
                if text == "" { enables[3] = false }
                else { enables[3] = true }
            } else {
                setInvalid(marginView: marginViews[3], validLabel: validLabels[3])
                enables[3] = false
            }
        }
        
        if enables.filter({ $0 == true }).count == 5 {
            signupButton.isUserInteractionEnabled = true
        } else {
            signupButton.isUserInteractionEnabled = false
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

extension SignupVC: XibButtonDelegate {
    func clickButton(of sex: Sex) {
        enables[4] = true
        switch sex {
        case .man:
            sexButtons[0].setSelectedState(by: true)
            sexButtons[1].setSelectedState(by: false)
            gender = "MAN"
        case .woman:
            sexButtons[0].setSelectedState(by: false)
            sexButtons[1].setSelectedState(by: true)
            gender = "WOMAN"
        }
        
        if enables.filter({ $0 == true }).count == 5 {
            signupButton.isUserInteractionEnabled = true
        } else {
            signupButton.isUserInteractionEnabled = false
        }
    }
}
