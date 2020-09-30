//
//  LogoutPopupVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/28.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class TwoButtonPopupVC: UIViewController {
    static let identifier = "TwoButtonPopupVC"
    
    enum PopupCategory {
        case logout
        case deleteReview
        case guestMode
    }
    
    var popupCategory: PopupCategory?
    
    // MARK: - 확인 버튼 눌렀을 때, 일어날 액션
    var completion: (() -> Void)?
    

    // MARK: - 팝업 배경 뷰 설정
    @IBOutlet weak var popupView: UIView! {
        didSet {
            popupView.makeShadow(color: UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 0.7), blur: 20, x: 3, y: 3)
        }
    }
    
    @IBOutlet weak var icTopConstraint: NSLayoutConstraint!
    
    // ic Top Constant 조절
    private func setIcPopupImageLayout() {
        let icImageViewWidth = popupView.frame.width * 0.3
        let icImageViewHeight = icImageViewWidth * (3/4)
        let topConstant = icImageViewHeight * 0.67
        icTopConstraint.constant = -topConstant
        popupView.layer.cornerRadius = popupView.frame.width / 17
    }
    
    // MARK: - 팝업 뷰 타이틀 라벨 설정
    @IBOutlet weak var popupTitleLabel: UILabel!
    
    // MARK: - 팝업 뷰 라벨 설정
    @IBOutlet weak var popupLabel: UILabel!
    
    // 팝업 뷰 라벨의 Top Constraint
    @IBOutlet weak var popupLabelTopConstraint: NSLayoutConstraint!
    
    private func setPopupLabelTopConstraint() {
        popupLabelTopConstraint.constant = popupView.frame.height / 3.02
    }
    
    // MARK: - 버튼 설정
    @IBOutlet var buttons: [CustomButton]! {
        didSet {
            buttons.forEach { element in
                element.locationButton = .logoutPopupView
            }
        }
    }
    
    private func setButtonsLayerLayout() {
        buttons.forEach { element in
            element.layer.cornerRadius = element.frame.width / 5.9
            element.clipsToBounds = true
        }
    }
    
    // 취소
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // 로그 아웃 - Token 값 삭제, 초기 화면으로 돌아가기
    @IBAction func logout(_ sender: Any) {
        self.dismiss(animated: false) {
            self.completion?()
        }
    }
    
    // MARK: UIViewController viewDidLoad() override 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setLabelByLanguage()
    }
    
    private func setLabelByLanguage() {
        switch popupCategory {
        case .logout:
            popupLabel.text = "정말 로그아웃 하시겠습니까?".localized
            buttons[0].setTitle("취소".localized, for: .normal)
            buttons[1].setTitle("로그아웃".localized, for: .normal)
        case .deleteReview:
            popupLabel.text = "정말 삭제하시겠습니까?".localized
            buttons[0].setTitle("취소".localized, for: .normal)
            buttons[1].setTitle("삭제".localized, for: .normal)
        case .guestMode:
            popupTitleLabel.text = "로그인이 필요한 서비스입니다.".localized
            popupLabel.text = "로그인을 해주세요!".localized
            buttons[0].setTitle("취소".localized, for: .normal)
            buttons[1].setTitle("로그인 하기".localized, for: .normal)
        case .none:
            return
        }
    }
    
    // MARK: UIViewController viewDidLayoutSubviews() override 설정
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setIcPopupImageLayout()
        setPopupLabelTopConstraint()
        setButtonsLayerLayout()
    }
}
