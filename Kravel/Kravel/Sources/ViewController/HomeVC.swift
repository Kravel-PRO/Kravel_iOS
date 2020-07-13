//
//  HomeVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/13.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        exaa()
    }
    
    private func exaa() {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        var popUpView: UIView = {
            let backView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 300, width: self.view.frame.width, height: 300))
            backView.backgroundColor = .black
            return backView
        }()
        
        window?.addSubview(popUpView)
    }
}
