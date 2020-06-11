//
//  WelcomeVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/06/10.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    @IBOutlet weak var goTripButton: UIButton! {
        willSet {
            guard let goTripButton = newValue as? CustomButton else { return }
            goTripButton.locationButton = .welcomeView
        }
    }
    
    @IBOutlet weak var illustrateTopConstraint: NSLayoutConstraint!
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
