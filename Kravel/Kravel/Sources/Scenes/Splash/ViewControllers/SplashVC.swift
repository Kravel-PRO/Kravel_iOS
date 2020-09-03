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
        animationView = AnimationView(name: "splash_iOS")
        animationView?.backgroundColor = .white
        animationView?.contentMode = .scaleToFill
        animationView?.translatesAutoresizingMaskIntoConstraints = false
        animationView?.play()
        
        self.view.addSubview(animationView!)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(overSplash), userInfo: nil, repeats: false)
    }
    
    // 스플래쉬 화면 끝나고 다음화면으로 넘어가기
    @objc func overSplash() {
        animationView?.removeFromSuperview()
        animationView = nil
        
        guard let languageVC = UIStoryboard(name: "SetLanguage", bundle: nil).instantiateViewController(withIdentifier: SetLanguageVC.identifier) as? SetLanguageVC else { return }
        
        guard let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
        keyWindow.rootViewController = languageVC
        
        // FIXME: 여기서 언어 설정했는지 안했는지 판단해서 어느 화면으로 넘어갈지 로직 필요할 듯
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