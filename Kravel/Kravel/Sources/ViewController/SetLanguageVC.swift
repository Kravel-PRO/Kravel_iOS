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
    
    private var isSelected: [Bool] = [false, false, false]
    
    @IBOutlet weak var startButton: UIButton! {
        willSet {
            guard let customButton = newValue as? CustomButton else { return }
            customButton.locationButton = .textView
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
        default: break
        }
    }
    
    private func onePick() {
        
    }
}
