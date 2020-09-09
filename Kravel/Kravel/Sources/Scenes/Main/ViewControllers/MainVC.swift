//
//  ViewController.swift
//  Kravel
//
//  Created by 윤동민 on 2020/06/03.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    // MARK: - 초기 화면 로그인 버튼 설정
    @IBOutlet weak var signinButton: UIButton! {
        willSet {
            guard let signinButton = newValue as? CustomButton else { return }
            signinButton.locationButton = .initView
        }
    }
    
    // MARK: - 초기 화면 회원가입 버튼 설정
    @IBOutlet weak var signupButton: UIButton! {
        willSet {
            guard let signupButton = newValue as? CustomButton else { return }
            signupButton.locationButton = .initView
        }
    }
    
    // 회원가입 화면으로 가기
    @IBAction func goSignupView(_ sender: Any) {
        guard let signupVC = UIStoryboard(name: "Signup", bundle: nil).instantiateViewController(withIdentifier: SignupVC.identifier) as? SignupVC else { return }
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    // MARK: - 초기 화면 Title Label 설정
    @IBOutlet weak var titleLabel: UILabel! 
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - 로그인 버튼 클릭 시 나오는 창 설정
    @IBOutlet weak var loginTextViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginTextView: LoginTextView! {
        didSet {
            loginTextView.textViewDelegate = self
            loginTextView.delegate = self
        }
    }
    
    // 로그인 Text View 상태에 따라 Animation 설정
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
    
    // MARK: - UIViewController viewDidLoad Override
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addGesture()
        setTextByLanguage()
    }
    
    private func setTextByLanguage() {
        signinButton.setTitle("로그인 하기".localized, for: .normal)
        signupButton.setTitle("회원가입 하기".localized, for: .normal)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let attributedString = NSMutableAttributedString(string: "오늘도\nKravel과 함께\n여행을 떠나볼까요?".localized, attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 24), .paragraphStyle: paragraphStyle])
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: (("오늘도\nKravel과 함께\n여행을 떠나볼까요?").localized as NSString).range(of: ("오늘도").localized))
        titleLabel.attributedText = attributedString
        titleLabel.alpha = 0
    }
    
    // MARK: - UIViewController viewWillAppear Override
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        addKeyboardObserver()
    }
    
    // MARK: - UIViewController viewDIdDisappear Override
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardObserver()
    }
    
    // MARK: - UIViewContollre viewDidLayoutSubviews Override
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loginTextView.setMarginViewsLayout()
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
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self)
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
    // FIXME: ID, PW 입력안한 경우 팝업창 뜨게 고치기
    func clickLoginButton(id: String, pw: String) {
        loginTextView.emailTextField.resignFirstResponder()
        loginTextView.pwTextField.resignFirstResponder()
        
        let signinParameter = SigninParameter(loginEmail: id, loginPw: pw)
        
        NetworkHandler.shared.requestAPI(apiCategory: .signin(signinParameter)) { result in
            switch result {
            // 성공한 경우 Token 값 저장 -> 다음 화면으로 넘어가기
            case .success(let token):
                // 받은 Token 값 저장
                guard let token = token as? String else { return }
                UserDefaults.standard.set(token, forKey: UserDefaultKey.token)
                
                // 메인 화면으로 이동
                guard let mainTabVC = UIStoryboard(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "MainTabVC") as? UITabBarController else { return }
                mainTabVC.modalPresentationStyle = .fullScreen
                self.present(mainTabVC, animated: true, completion: nil)
                
            // ID, PW 다른 경우 Error 처리
            case .requestErr(let message):
                print(message)
                guard let loginPopupVC = UIStoryboard(name: "LoginPopup", bundle: nil).instantiateViewController(withIdentifier: LoginPopupVC.identifier) as? LoginPopupVC else { return }
                loginPopupVC.modalPresentationStyle = .overFullScreen
                loginPopupVC.titleMessage = "로그인을 실패했습니다."
                loginPopupVC.message = "존재하지 않는 계정\n또는 비밀번호가 잘못되었습니다."
                self.present(loginPopupVC, animated: false, completion: nil)
                
            case .serverErr:
                print("ServrError")
                
            // 네트워크 연결 안 된 경우 Error 처리
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
}

