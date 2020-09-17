//
//  LoginPopupVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/28.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class LoginPopupVC: UIViewController {
    static let identifier = "LoginPopupVC"
    
    // MARK: - 팝업 뷰 설정
    @IBOutlet weak var popupView: UIView! {
        didSet {
            popupView.makeShadow(color: UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 0.7), blur: 20, x: 3, y: 3)
        }
    }
    
    // 팝업 화면 레이아웃 설정
    private func setPopupViewLayout() {
        popupView.layer.cornerRadius = popupView.frame.width / 17
    }
    
    // MARK: - 로그인 실패 제목 라벨 설정
    @IBOutlet weak var titleLabel: UILabel!
    
    var titleMessage: String?
    
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    
    // 타이틀 Top Constraint 설정
    private func setTitleTopConstraint() {
        titleTopConstraint.constant = popupView.frame.height / 7.12
    }
    
    // MARK: - 로그인 실패 설명 라벨 설정
    @IBOutlet weak var messageLabel: UILabel!
    
    var message: String?
    
    // MARK: - 확인 버튼 설정
    @IBOutlet weak var completeButton: CustomButton! {
        didSet {
            completeButton.locationButton = .logoutPopupView
            completeButton.setTitle("확인".localized, for: .normal)
        }
    }
    
    // 확인 버튼 Layout 설정
    private func setCompleteButtonLayout() {
        completeButton.layer.cornerRadius = completeButton.frame.width / 12.26
        completeButton.clipsToBounds = true
    }
    
    // 확인 버튼 클릭
    @IBAction func complete(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - UIViewController viewDidLoad() Override 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleLabel.text = titleMessage
        titleLabel.sizeToFit()
        messageLabel.text = message
        messageLabel.sizeToFit()
    }
    
    // MARK: - UIViewController viewDidLayoutSubviews() Override 설정
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCompleteButtonLayout()
        setPopupViewLayout()
        setTitleTopConstraint()
    }
}
