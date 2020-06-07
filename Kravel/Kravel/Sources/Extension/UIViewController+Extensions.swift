//
//  UIViewController+Extensions.swift
//  Kravel
//
//  Created by 윤동민 on 2020/06/07.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

extension UIViewController {
    func setTransparentNav() {
        let bar: UINavigationBar! = self.navigationController?.navigationBar
        
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
    }
}
