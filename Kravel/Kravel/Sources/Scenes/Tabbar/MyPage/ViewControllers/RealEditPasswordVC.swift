//
//  RealEditPasswordVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/27.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class RealEditPasswordVC: UIViewController {
    static let identifier = "RealEditPasswordVC"
    
    var naviTitle: String?
    var isEnables: [Bool] = [false, false, false]

    // MARK: - TextView 바탕 Layer 설정
    @IBOutlet var marginViews: [UIView]! {
        didSet {
            marginViews.forEach { view in
                view.layer.borderColor = UIColor.veryLightPink.cgColor
                view.layer.borderWidth = 1
                view.layer.cornerRadius = view.frame.width / 15
            }
        }
    }
    
    // MARK: - PW 확인하는 TextField
    @IBOutlet weak var checkPwTextField: UITextField! {
        didSet {
            checkPwTextField.delegate = self
        }
    }
    
    @IBOutlet weak var checkPwLabel: UILabel!
    
    // MARK: - PW 입력하는 TextField
    @IBOutlet weak var pwTextField: UITextField! {
        didSet {
            pwTextField.delegate = self
        }
    }
    
    @IBOutlet weak var pwLabel: UILabel!
    @IBOutlet weak var pwvalidLabel: UILabel!
    
    // MARK: - PW 한번 더 입력하는 TextField
    @IBOutlet weak var oneMoreTextField: UITextField! {
        didSet {
            oneMoreTextField.delegate = self
        }
    }
    
    @IBOutlet weak var oneMoreLabel: UILabel!
    @IBOutlet weak var onemorevalidLabel: UILabel!
    
    // MARK: - 수정 완료 버튼 설정
    @IBOutlet weak var completeButton: CustomButton! {
        didSet {
            completeButton.locationButton = .editPasswordView
        }
    }
    
    @IBAction func complete(_ sender: Any) {
        requestModifyPassword()
    }
    
    // MARK: - UIViewController viewDidLoad() Override
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setLabelByLanguage()
    }
    
    private func setLabelByLanguage() {
        checkPwLabel.text = "본인 확인을 위해 비밀번호를 입력해주세요.".localized
        checkPwTextField.placeholder = "6자리 이상 입력해주세요.".localized
        
        pwLabel.text = "변경할 비밀번호를 입력해주세요.".localized
        pwTextField.placeholder = "6자리 이상 입력해주세요.".localized
        
        oneMoreLabel.text = "비밀번호 확인".localized
        oneMoreTextField.placeholder = "다시 한 번 비밀번호를 입력해주세요.".localized
        
        completeButton.setTitle("수정 완료".localized, for: .normal)
        
        pwvalidLabel.text = "6자리 이상 입력해주세요.".localized
        onemorevalidLabel.text = "비밀번호가 같지 않습니다.".localized
        
        pwvalidLabel.alpha = 0
        onemorevalidLabel.alpha = 0
    }
    
    // MARK: - UIViewController viewWillAppear() Override
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    private func setNav() {
        let backImage = UIImage(named: ImageKey.back)
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = naviTitle
    }
}

extension RealEditPasswordVC {
    // MARK: - 비밀번호 수정 API 연결
    private func requestModifyPassword() {
        let changeInfoParameter = ChangeInfoBodyParameter(loginPw: "", modifyLoginPw: "", gender: "", nickName: "", speech: "")
        
        NetworkHandler.shared.requestAPI(apiCategory: .changInfo(queryType: "password", body: changeInfoParameter)) { result in
            switch result {
            case .success(let successData):
                print(successData)
            case .requestErr:
                print("Request Err")
            case .serverErr:
                print("Server Err")
            case .networkFail:
                print("networkFail")
            }
        }
    }
}

extension RealEditPasswordVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let layerColor: UIColor = text != "" ? UIColor(red: 253/255, green: 9/255, blue: 9/255, alpha: 1.0) : .veryLightPink
        
        if textField == checkPwTextField {
            marginViews[0].layer.borderColor = layerColor.cgColor
            
            if text.count >= 6 || text == "" {
                marginViews[0].backgroundColor = .white
                if text == "" { isEnables[0] = false }
                else { isEnables[0] = true }
            } else {
                marginViews[0].backgroundColor = UIColor.grapefruit.withAlphaComponent(0.15)
                isEnables[0] = false
            }
        } else if textField == pwTextField {
            marginViews[1].layer.borderColor = layerColor.cgColor
            
            if text.count >= 6 || text == "" {
                marginViews[1].backgroundColor = .white
                UIView.animate(withDuration: 0.3) {
                    self.pwvalidLabel.alpha = 0
                }
                
                if text == "" { isEnables[1] = false }
                else { isEnables[1] = true }
            } else {
                marginViews[1].backgroundColor = UIColor.grapefruit.withAlphaComponent(0.15)
                UIView.animate(withDuration: 0.3) {
                    self.pwvalidLabel.alpha = 1
                }
                
                isEnables[1] = false
            }
            
            if text == oneMoreTextField.text && text != "" || oneMoreTextField.text == "" {
                marginViews[2].backgroundColor = UIColor.white
                UIView.animate(withDuration: 0.3) {
                    self.onemorevalidLabel.alpha = 0
                }
                
                if oneMoreTextField.text == "" { isEnables[2] = false }
                else { isEnables[2] = true }
            } else {
                marginViews[2].backgroundColor = UIColor.grapefruit.withAlphaComponent(0.15)
                UIView.animate(withDuration: 0.3) {
                    self.onemorevalidLabel.alpha = 1
                }
                
                isEnables[2] = false
            }
        } else {
            marginViews[2].layer.borderColor = layerColor.cgColor
            
            if text == pwTextField.text || text == "" {
                marginViews[2].backgroundColor = .white
                
                UIView.animate(withDuration: 0.3) {
                    self.onemorevalidLabel.alpha = 0
                }
                if text == "" { isEnables[2] = false }
                else { isEnables[2] = true }
            } else {
                marginViews[2].backgroundColor = UIColor.grapefruit.withAlphaComponent(0.15)
                
                UIView.animate(withDuration: 0.3) {
                    self.onemorevalidLabel.alpha = 1
                }
                isEnables[2] = false
            }
        }
        
        if isEnables.filter({ $0 == true }).count == 3 {
            completeButton.isUserInteractionEnabled = true
        } else {
            completeButton.isUserInteractionEnabled = false
        }
    }
}
