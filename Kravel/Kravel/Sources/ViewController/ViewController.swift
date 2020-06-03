//
//  ViewController.swift
//  Kravel
//
//  Created by 윤동민 on 2020/06/03.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var signinButton: UIButton! {
        willSet {
            guard let signinButton = newValue as? SignButton else { return }
            signinButton.locationButton = .initView
        }
    }
    
    @IBOutlet weak var signupButton: UIButton! {
        willSet {
            guard let signupButton = newValue as? SignButton else { return }
            signupButton.locationButton = .initView
        }
    }
    
    @IBOutlet weak var loginTextView: LoginTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

