//
//  LoginRequireVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/10/01.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class LoginRequireVC: UIViewController {
    static let identifier = "LoginRequireVC"

    // MARK: - 설명 라벨 설정
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - 로그인 화면으로 가는 버튼
    @IBOutlet weak var loginButton: CustomButton! {
        didSet {
            loginButton.locationButton = .galleryUploadPhotoView
            loginButton.setTitle("로그인 하기".localized, for: .normal)
        }
    }
    
    @IBAction func goLogin(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.guestMode)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.token)
        guard let startRootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "StartRoot") as? UINavigationController else { return }
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
        window.rootViewController = startRootVC
    }
    
    // MARK: - UIViewController viewDidLoad Override
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setLabelByLanguage()
    }
    
    private func setLabelByLanguage() {
        messageLabel.text = "로그인을 하면\nKravel이 당신 주변의\n멋진 여행지를 추천해줘요!".localized
        messageLabel.sizeToFit()
    }
}
