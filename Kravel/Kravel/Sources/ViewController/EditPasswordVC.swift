//
//  EditPasswordVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/27.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class EditPasswordVC: UIViewController {
    static let identifier = "EditPasswordVC"
    
    var naviTitle: String?
    
    // MARK: - 안내 라벨 설정
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - TextField Margin View 설정
    @IBOutlet weak var marginView: UIView! {
        didSet {
            marginView.layer.borderColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0).cgColor
            marginView.layer.borderWidth = 1
            marginView.layer.cornerRadius = marginView.frame.width / 15
        }
    }
    
    // MARK: - 비밀번호 TextField 설정
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
        }
    }
    
    // MARK: - 수정 완료 버튼 설정
    @IBOutlet weak var completeButton: CustomButton! {
        didSet {
            completeButton.locationButton = .editPasswordView
        }
    }
    
    // MARK: - UIViewController override viewDidLoad() 부분
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UIViewController override viewWillAppear() 부분
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    private func setNav() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)]
        self.navigationItem.title = naviTitle
    }
}

extension EditPasswordVC {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension EditPasswordVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let layerColor: UIColor = text != "" ? UIColor(red: 253/255, green: 9/255, blue: 9/255, alpha: 1.0) : .veryLightPink
        marginView.layer.borderColor = layerColor.cgColor
    }
}
