//
//  WelcomeVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/06/10.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    static let identifier = "WelcomeVC"
    
    // MARK: - 타이틀 라벨
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - 메세지 라벨
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - 시작하기 버튼
    @IBOutlet weak var goTripButton: UIButton! {
        willSet {
            guard let goTripButton = newValue as? CustomButton else { return }
            goTripButton.locationButton = .welcomeView
        }
    }
    
    @IBOutlet weak var illustrateTopConstraint: NSLayoutConstraint!
    
    // MARK: - 다음 화면으로 넘어가기
    @IBAction func goNext(_ sender: Any) {
        guard let rootTab = UIStoryboard(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "MainTabVC") as? UITabBarController else { return }
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
        window.rootViewController = rootTab
    }
    
    // MARK: - UIViewController viewDidLoad Override 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setLabelByLangauge()
    }
    
    private func setLabelByLangauge() {
        titleLabel.text = "환영합니다!".localized
        messageLabel.text = "K-culture와 함께하는 색다른 한국여행.\n한국 드라마/영화 속 나온 촬영지와\nK-POP 스타가 다녀간 장소에서\n당신만의 추억을 만들어보세요.".localized
        goTripButton.setTitle("여행 떠나기".localized, for: .normal)
    }
    
    // MARK: - UIViewController viewDidLayoutSubviews Override 설정
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        illustrateTopConstraint.constant = self.view.frame.height / 4.5
    }
}
