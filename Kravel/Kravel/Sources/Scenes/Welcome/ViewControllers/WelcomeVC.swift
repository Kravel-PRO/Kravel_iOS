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
    
    @IBOutlet weak var goTripButton: UIButton! {
        willSet {
            guard let goTripButton = newValue as? CustomButton else { return }
            goTripButton.locationButton = .welcomeView
        }
    }
    
    @IBOutlet weak var illustrateTopConstraint: NSLayoutConstraint!
    
    @IBAction func goNext(_ sender: Any) {
        guard let rootNav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartRoot") as? UINavigationController else { return }
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
        window.rootViewController = rootNav
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        illustrateTopConstraint.constant = self.view.frame.height / 4.5
    }
}
