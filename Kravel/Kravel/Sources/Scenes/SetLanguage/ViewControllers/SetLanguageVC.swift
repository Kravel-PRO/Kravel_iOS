//
//  SetLanguageVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/06/04.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class SetLanguageVC: UIViewController {
    static let identifier = "SetLanguageVC"
    
    // MARK: NavigationController 설정
   var navTitle: String?
   
   private func setNav() {
       self.navigationController?.navigationBar.isHidden = false
       self.navigationController?.navigationBar.topItem?.title = ""
       self.navigationController?.navigationBar.tintColor = .black
       self.navigationItem.title = navTitle
       self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)]
       self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
   }
    
    // MARK: - 언어 버튼들 설정
    @IBOutlet var languageButtons: [UIButton]! {
        willSet {
            newValue.forEach { button in
                guard let customButton = button as? CustomButton else { return }
                customButton.locationButton = .languageView(isSelected: false)
            }
        }
    }
    
    // 선택된 언어 저장
    var selectedLanguageButton: Language?
    
    // MARK: - 완료 버튼 설정
    @IBOutlet weak var startButton: UIButton! {
        willSet {
            guard let customButton = newValue as? CustomButton else { return }
            customButton.isUserInteractionEnabled = false
            customButton.locationButton = .languageViewStart
        }
    }
    
    // Complete 버튼에 들어가는 텍스트
    var completeButtonText: String? = "Start Kravel"
    
    private func setStartButtonText() {
        startButton.setTitle(completeButtonText, for: .normal)
    }
    
    // 완료 버튼 Call Back
    lazy var complete: ((Language) -> Void) = { [weak self] language in
        guard let startVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "StartRoot") as? UINavigationController else { return }
        startVC.modalPresentationStyle = .fullScreen
        self?.present(startVC, animated: true, completion: nil)
    }
    
    // MARK: ViewController Override 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setStartButtonText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    // MARK: - 언어 버튼 클릭했을 때, 하나만 선택되는 알고리즘
    @IBAction func selectLanguage(_ sender: Any) {
        guard let languageButton = sender as? CustomButton else { return }
        switch languageButton.locationButton {
        case .languageView(let isSelected):
            languageButton.locationButton = .languageView(isSelected: !isSelected)
            languageButton.layer.borderColor = !isSelected ? UIColor.grapefruit.cgColor : UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0).cgColor
            languageButton.setTitleColor(!isSelected ? UIColor.grapefruit : UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0), for: .normal)
            
            if !isSelected {
                guard let button = sender as? UIButton else { return }
                if button == languageButtons[0] { selectedLanguageButton = .korean }
                else { selectedLanguageButton = .english }
                startButton.isUserInteractionEnabled = true
                startButton.setTitleColor(.white, for: .normal)
                startButton.backgroundColor = .grapefruit
                for button in languageButtons {
                    if button == languageButton { continue }
                    guard let otherButton = button as? CustomButton else { return }
                    otherButton.locationButton = .languageView(isSelected: false)
                }
            } else {
                startButton.isUserInteractionEnabled = false
                startButton.setTitleColor(.veryLightPink, for: .normal)
                startButton.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
            }
        default: break
        }
    }
    
    // MARK: - 언어 설정 완료
    @IBAction func start(_ sender: Any) {
        // 선택한 언어 핸드폰에 저장
        switch selectedLanguageButton {
        case .korean: UserDefaults.standard.set("KOR", forKey: "Language")
        case .english: UserDefaults.standard.set("ENG", forKey: "Language")
        case .none: return
        }
        if let selectedButton = self.selectedLanguageButton { complete(selectedButton) }
    }
}
