//
//  NetworkFailPopupVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/03.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class NetworkFailPopupVC: UIViewController {
    static let identifier = "NetworkFailPopupVC"
    
    var completionHandler: (() -> Void)?
    
    // MARK: - 팝업 배경 뷰 설정
    @IBOutlet weak var popupView: UIView! {
        didSet {
            popupView.makeShadow(color: UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 0.7), blur: 20, x: 3, y: 3)
        }
    }
    
    // MARK: - Icon Top Constraint 설정하기
    @IBOutlet weak var icImageTopConstraint: NSLayoutConstraint!
    
    private func setIcImageTopConstraint() {
        let icImageViewWidth = popupView.frame.width * 0.36
        let icImageViewHeight = icImageViewWidth * 23 / 29
        let topConstraint = icImageViewHeight * 0.56
        icImageTopConstraint.constant = -topConstraint
        popupView.layer.cornerRadius = popupView.frame.width / 31.5
    }
    
    // MARK: - 팝업 Title Label 설정
    @IBOutlet weak var popupTitleLabel: UILabel! {
        didSet {
            popupTitleLabel.text = "네트워크 연결이 끊겼습니다.".localized
            popupTitleLabel.sizeToFit()
        }
    }
    
    // MARK: - 팝업 Message Label 설정
    @IBOutlet weak var popupMessageLabel: UILabel! {
        didSet {
            popupMessageLabel.text = "네트워크 상태를 확인해주세요.\n문제가 계속되면 잠시 후 다시 시도해주세요.".localized
            popupMessageLabel.sizeToFit()
        }
    }
    
    // MARK: - 확인하기 버튼
    @IBOutlet weak var completeButton: CustomButton! {
        didSet {
            completeButton.locationButton = .logoutPopupView
            completeButton.setTitle("확인".localized, for: .normal)
        }
    }
    
    private func setCompleteButtonLayout() {
        completeButton.layer.cornerRadius = completeButton.frame.width / 12.26
        completeButton.clipsToBounds = true
    }
    
    @IBAction func complete(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        completionHandler?()
    }
    
    // MARK: - UIViewController viewDidLoad 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: UIViewController viewDidLayoutSubviews 설정
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setIcImageTopConstraint()
        setCompleteButtonLayout()
    }
}
