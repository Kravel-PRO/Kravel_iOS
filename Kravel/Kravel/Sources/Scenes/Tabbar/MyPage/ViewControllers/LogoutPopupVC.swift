//
//  LogoutPopupVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/28.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class LogoutPopupVC: UIViewController {
    static let identifier = "LogoutPopupVC"

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
    
    // MARK: - 팝업 뷰 라벨 설정
    @IBOutlet weak var popupLabel: UILabel!
    
    // 팜업 뷰 라벨 이름
    var popupDesctiption: String? {
        didSet {
            popupLabel.text = popupDesctiption
            popupLabel.sizeToFit()
        }
    }
    
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
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.token)
        guard let startRootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "StartRoot") as? UINavigationController else { return }
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.loginId)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.loginPw)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.token)
        window.rootViewController = startRootVC
    }
    
    // MARK: UIViewController viewDidLoad() override 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setLabelByLanguage()
    }
    
    private func setLabelByLanguage() {
        popupLabel.text = "정말 로그아웃 하시겠습니까?".localized
        buttons[0].setTitle("취소".localized, for: .normal)
        buttons[1].setTitle("로그아웃".localized, for: .normal)
    }
    
    // MARK: UIViewController viewDidLayoutSubviews() override 설정
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setIcPopupImageLayout()
        setPopupLabelTopConstraint()
        setButtonsLayerLayout()
    }
}
