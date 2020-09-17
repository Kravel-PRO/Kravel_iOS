//
//  SignupFailVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/18.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class SignupFailVC: UIViewController {
    static let identifier = "SignupFailVC"

    // MARK: - 팝업 뷰 설정
    @IBOutlet weak var popupView: UIView! {
        didSet {
            popupView.makeShadow(color: UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 0.7), blur: 20, x: 3, y: 3)
            popupView.clipsToBounds = false
        }
    }
    
    // MARK: - 타이틀 라벨
    @IBOutlet weak var titleLabel: UILabel!
    
    var titleMessage: String? {
        didSet {
            titleLabel.text = titleMessage
            titleLabel.sizeToFit()
        }
    }
    
    // MARK: - 확인 버튼
    @IBOutlet weak var completeButton: CustomButton! {
        didSet {
            completeButton.locationButton = .logoutPopupView
            completeButton.setTitle("확인".localized, for: .normal)
        }
    }
    
    @IBAction func complete(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - UIViewController viewDidLoad Override 설정
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - UIViewController viewDidLayoutSubviews Override 설정
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        popupView.layer.cornerRadius = popupView.frame.width / 31.5
    }
}
