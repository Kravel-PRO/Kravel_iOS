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
    
    // MARK: - PW 입력하는 TextField
    @IBOutlet weak var pwTextField: UITextField! {
        didSet {
            pwTextField.delegate = self
        }
    }
    
    // MARK: - PW 한번 더 입력하는 TextField
    @IBOutlet weak var oneMoreTextField: UITextField! {
        didSet {
            oneMoreTextField.delegate = self
        }
    }
    
    // MARK: - 수정 완료 버튼 설정
    @IBOutlet weak var completeButton: CustomButton! {
        didSet {
            completeButton.locationButton = .editPasswordView
        }
    }
    
    // MARK: - UIViewController viewDidLoad() Override
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UIViewController viewWillAppear() Override
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    private func setNav() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "비밀번호 수정"
    }
}

extension RealEditPasswordVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let layerColor: UIColor = text != "" ? UIColor(red: 253/255, green: 9/255, blue: 9/255, alpha: 1.0) : .veryLightPink
        
        if textField == pwTextField {
            marginViews[0].layer.borderColor = layerColor.cgColor
        } else {
            marginViews[1].layer.borderColor = layerColor.cgColor
        }
    }
}
