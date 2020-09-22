//
//  SplashVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/30.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit
import Lottie

class SplashVC: UIViewController {
    // MARK: - 스플래쉬 화면 Lottie 설정
    private var animationView: AnimationView?
    
    private func showLoadingLottie() {
        animationView = AnimationView(name: LottieFile.splash)
        animationView?.backgroundColor = .white
        animationView?.contentMode = .scaleAspectFill
        animationView?.translatesAutoresizingMaskIntoConstraints = false
        animationView?.play()
        
        self.view.addSubview(animationView!)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(overSplash), userInfo: nil, repeats: false)
    }
    
    // 스플래쉬 화면 끝나고 다음화면으로 넘어가기
    @objc func overSplash() {
        animationView?.removeFromSuperview()
        animationView = nil
        
        guard let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
        
        if UserDefaults.standard.object(forKey: UserDefaultKey.token) != nil {
            print("notNil")
            guard let rootTab = UIStoryboard(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "MainTabVC") as? UITabBarController else { return }
            keyWindow.rootViewController = rootTab
        } else {
            guard let languageVC = UIStoryboard(name: "SetLanguage", bundle: nil).instantiateViewController(withIdentifier: SetLanguageVC.identifier) as? SetLanguageVC else { return }
            keyWindow.rootViewController = languageVC
        }
    }
    
    // MARK: - 토큰의 만료기간 검사해서 만료된 경우 발급받는 로직 추가
    private func isOverToken() {
        
    }

    // MARK: - UIViewController viewDidLoad Override 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showLoadingLottie()
    }
    
    // MARK: - UIViewController viewDidLayoutSubviews Override 설정
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setAnimationViewLayout()
    }
    
    private func setAnimationViewLayout() {
        guard let animationView = self.animationView else { return }
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            animationView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
