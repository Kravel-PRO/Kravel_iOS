//
//  SetLanguageVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/06/04.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class SetLanguageVC: UIViewController {
    
    @IBOutlet var languageButtons: [UIButton]! {
        willSet {
            newValue.forEach { button in
                guard let customButton = button as? CustomButton else { return }
                customButton.locationButton = .languageView(isSelected: false)
            }
        }
    }
    
    @IBOutlet weak var startButton: UIButton! {
        willSet {
            guard let customButton = newValue as? CustomButton else { return }
            customButton.isUserInteractionEnabled = false
            customButton.locationButton = .languageViewStart
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.        
    }

    @IBAction func selectLanguage(_ sender: Any) {
        guard let languageButton = sender as? CustomButton else { return }
        switch languageButton.locationButton {
        case .languageView(let isSelected):
            languageButton.locationButton = .languageView(isSelected: !isSelected)
            languageButton.layer.borderColor = !isSelected ? UIColor.grapefruit.cgColor : UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0).cgColor
            languageButton.setTitleColor(!isSelected ? UIColor.grapefruit : UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0), for: .normal)
            
            if !isSelected {
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
    
    @IBAction func start(_ sender: Any) {
        languageButtons.forEach { button in
            guard let button = button as? CustomButton else { return }
            switch button.locationButton {
            case .languageView(let isSelected):
                if isSelected {
                    guard let startVC = self.storyboard?.instantiateViewController(identifier: "StartRoot") as? UINavigationController else { return }
                    startVC.modalPresentationStyle = .fullScreen
                    self.present(startVC, animated: true, completion: nil)
                    return
                }
            default: return
            }
        }
    }
}
