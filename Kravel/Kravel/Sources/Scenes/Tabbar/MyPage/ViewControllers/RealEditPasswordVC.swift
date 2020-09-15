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
    
    // MARK: - PW 한번 더 입력하는 TextField
    @IBOutlet weak var oneMoreTextField: UITextField! {
        didSet {
            oneMoreTextField.delegate = self
        }
    }
    
    @IBOutlet weak var oneMoreLabel: UILabel!
    
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
        let changeInfoParameter = ChangeInfoBodyParameter(loginPw: "", modifyLoginPw: "", gender: "", nickName: "")
        
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
        
        if textField == pwTextField {
            marginViews[0].layer.borderColor = layerColor.cgColor
        } else if textField == oneMoreTextField {
            marginViews[1].layer.borderColor = layerColor.cgColor
        } else {
            marginViews[2].layer.borderColor = layerColor.cgColor
        }
    }
}
