//
//  ChangeInfoVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/14.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class ChangeInfoVC: UIViewController {
    static let identifier = "ChangeInfoVC"
    
    var selectedSex: String = ""
    
    // MARK: - Navigation Bar 설정
    var naviTitle: String?
    
    // MARK: - 라벨들 설정
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var nickNameVaildLabel: UILabel! {
        didSet {
            nickNameVaildLabel.alpha = 0
        }
    }
    
    // MARK: - 닉네임 수정 화면 설정
    @IBOutlet weak var nicknameBackView: UIView! {
        didSet {
            nicknameBackView.layer.cornerRadius = nicknameBackView.frame.width / 14.9
            nicknameBackView.layer.borderWidth = 1
            nicknameBackView.layer.borderColor = UIColor.veryLightPink.cgColor
            nicknameBackView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nicknameTextField: UITextField! {
        didSet {
            nicknameTextField.delegate = self
        }
    }
    
    // MARK: - 성별 버튼 설정
    @IBOutlet var sexButtons: [SexButton]! {
        didSet {
            sexButtons[0].sex = .man
            sexButtons[1].sex = .woman
            sexButtons.forEach { button in
                button.delegate = self
            }
        }
    }
    
    // MARK: - 회원 탈퇴하기 버튼
    @IBOutlet weak var withdrawlButton: UIButton! {
        didSet {
            withdrawlButton.isHidden = true
        }
    }
    
    // MARK: - 회원 탈퇴
    @IBAction func withdrawal(_ sender: Any) {
    }
    
    // MARK: - 수정 완료 버튼 설정
    @IBOutlet weak var completeButton: UIButton! {
        didSet {
            completeButton.isUserInteractionEnabled = false
            guard let customButton = completeButton as? CustomButton else { return }
            customButton.locationButton = .signupView
        }
    }
    
    @IBAction func completeEdit(_ sender: Any) {
        requestChangInfo()
    }
    
    // MARK: - UIViewController viewDidLoad Override 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelByLanguage()
    }
    
    private func setLabelByLanguage() {
        nickNameLabel.text = "닉네임".localized
        nickNameLabel.sizeToFit()
        
        sexLabel.text = "성별".localized + " " + "(" + "선택".localized + ")"
        sexLabel.sizeToFit()
        
        completeButton.setTitle("수정 완료".localized, for: .normal)
        nicknameTextField.placeholder = "닉네임을 입력해주세요.".localized
        nickNameVaildLabel.text = "7자 이하로 입력해주세요.".localized
    }
    
    
    // MARK: - UIViewController viewWillAppear Override 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    private func setNav() {
        let backImage = UIImage(named: ImageKey.back)
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = naviTitle
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)]
        self.navigationController?.navigationBar.tintColor = .black
    }
}

extension ChangeInfoVC {
    // MARK: - 정보 수정 API 연결
    private func requestChangInfo() {
        guard let modifiedNickName = self.nicknameTextField.text else { return }
        if selectedSex == "" { selectedSex = "MAN" }
        
        let changInfoBodyParameter = ChangeInfoBodyParameter(loginPw: "", modifyLoginPw: "", gender: selectedSex, nickName: modifiedNickName, speech: "KOR")
        
        NetworkHandler.shared.requestAPI(apiCategory: .changInfo(queryType: "nickNameAndGender", body: changInfoBodyParameter)) { result in
            switch result {
            case .success(let changeInfoResponse):
                guard let changeInfoResponse = changeInfoResponse as? ChangeInfoResponseData else { return }
                if let nickName = changeInfoResponse.nickName { UserDefaults.standard.set(nickName, forKey: UserDefaultKey.nickName) }
                self.navigationController?.popViewController(animated: true)
            case .requestErr(_): return
            case .serverErr:
                guard let loginPopupVC = UIStoryboard(name: "LoginPopup", bundle: nil).instantiateViewController(withIdentifier: LoginPopupVC.identifier) as? LoginPopupVC else { return }
                loginPopupVC.modalPresentationStyle = .overFullScreen
                loginPopupVC.titleMessage = "인증을 실패했습니다.".localized
                loginPopupVC.message = "비밀번호를 다시 입력해주세요.".localized
                self.present(loginPopupVC, animated: false, completion: nil)
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
}

extension ChangeInfoVC {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension ChangeInfoVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let layerColor: UIColor = text != "" ? UIColor(red: 253/255, green: 9/255, blue: 9/255, alpha: 1.0) : .veryLightPink
        
        nicknameBackView.layer.borderColor = layerColor.cgColor
        
        if text == "" || text.count > 7 {
            completeButton.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
            completeButton.setTitleColor(.veryLightPink, for: .normal)
            completeButton.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.3) {
                self.nickNameVaildLabel.alpha = 1.0
            }
        } else {
            completeButton.backgroundColor = .grapefruit
            completeButton.setTitleColor(.white, for: .normal)
            completeButton.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.3) {
                self.nickNameVaildLabel.alpha = 0
            }
        }
    }
}

extension ChangeInfoVC: XibButtonDelegate {
    func clickButton(of sex: Sex) {
        switch sex {
        case .man:
            selectedSex = "MAN"
            sexButtons[0].setSelectedState(by: true)
            sexButtons[1].setSelectedState(by: false)
        case .woman:
            selectedSex = "WOMAN"
            sexButtons[0].setSelectedState(by: false)
            sexButtons[1].setSelectedState(by: true)
        }
    }
}
