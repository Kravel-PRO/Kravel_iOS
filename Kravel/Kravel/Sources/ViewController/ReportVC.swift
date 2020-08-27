//
//  ReportVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/16.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class ReportVC: UIViewController {
    static let identifier = "ReportVC"
    
    // MARK: - NavigationController 설정
    var navTitle: String?
    
    private func setNav() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = navTitle
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)]
    }
    
    // MARK: - TextField들 설정
    @IBOutlet var textFields: [UITextField]! {
        didSet {
            textFields.forEach { textField in
                textField.delegate = self
            }
        }
    }
    
    // MARK: - TextField 바깥 Margin View 설정
    @IBOutlet var marginViews: [UIView]! {
        didSet {
            marginViews.forEach { view in
                view.layer.borderColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0).cgColor
                view.layer.borderWidth = 1
                view.layer.cornerRadius = view.frame.width / 15
            }
        }
    }
    
    // MARK: - 사진 업로드 Margin View 설정
    @IBOutlet weak var pictureUploadMarginView: UIView! {
        didSet {
            pictureUploadMarginView.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
            pictureUploadMarginView.layer.cornerRadius = pictureUploadMarginView.frame.width / 28.58
            pictureUploadMarginView.clipsToBounds = true
        }
    }
    
    // MARK: - 사진 업로드 부분 설정
    @IBAction func clickPictureUpload(_ sender: Any) {
        print("picture Upload")
    }
    
    // MARK: - 완성 버튼 설정
    @IBOutlet weak var compleButton: CustomButton! {
        didSet {
            compleButton.locationButton = .reportView
        }
    }
    
    // MARK: - UIViewController override 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    @IBOutlet var labelsSpacingConstraint: [NSLayoutConstraint]!
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setLabelsTopConstraint()
    }
    
    private func setLabelsTopConstraint() {
        labelsSpacingConstraint.forEach { constraint in
            constraint.constant = self.view.frame.height / 33.83
        }
    }
}

extension ReportVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let layerColor: UIColor = text != "" ? UIColor(red: 253/255, green: 9/255, blue: 9/255, alpha: 1.0) : .veryLightPink
        
        if textField == textFields[0] {
            marginViews[0].layer.borderColor = layerColor.cgColor
        } else if textField == textFields[1] {
            marginViews[1].layer.borderColor = layerColor.cgColor
        } else {
            marginViews[2].layer.borderColor = layerColor.cgColor
        }
    }
}
