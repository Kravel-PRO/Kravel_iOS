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
    
    // MARK: - Navigation Bar 설정
    var naviTitle: String?
    
    private func setNav() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = naviTitle
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)]
        self.navigationController?.navigationBar.tintColor = .black
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
    
    @IBOutlet weak var nicknameTextField: UITextField!
    
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
    
    // MARK: - 수정 완료 버튼 설정
    @IBOutlet weak var completeButton: UIButton! {
        didSet {
            guard let customButton = completeButton as? CustomButton else { return }
            customButton.locationButton = .signupView
        }
    }
    
    @IBAction func completeEdit(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - ViewController Override 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
}

extension ChangeInfoVC: XibButtonDelegate {
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
