//
//  Report2VC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/01.
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
    
    // MARK: - 메인 ScrollView 설정
    @IBOutlet weak var contentScrollView: UIScrollView! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTouched))
            gesture.numberOfTouchesRequired = 1
            contentScrollView.addGestureRecognizer(gesture)
            contentScrollView.delaysContentTouches = false
        }
    }
    
    @objc func viewTouched() {
        self.view.endEditing(true)
    }

    // MARK: - 안내하는 Label 설정
    @IBOutlet weak var guideLabel: UILabel! {
        didSet {
            guideLabel.text = "장소에 대한 설명이 자세할수록 업로드 될 확률이 높아요!"
            guideLabel.sizeToFit()
        }
    }
    
    // MARK: - TextFields들 Margin View 설정
    @IBOutlet var marginViews: [UIView]! {
        didSet {
            marginViews.forEach { view in
                view.layer.borderColor = UIColor.veryLightPink.cgColor
                view.layer.borderWidth = 1
                view.layer.cornerRadius = view.frame.width / 15
            }
        }
    }
    
    // MARK: - 제보하기 입력 창들 설정
    @IBOutlet var textFields: [UITextField]! {
        didSet {
            textFields.forEach { textField in
                textField.delegate = self
            }
        }
    }
    
    // MARK: - 장소에 대한 설명 입력하는 TextView 설정
    @IBOutlet weak var placeDescriptionTextView: UITextView! {
        didSet {
            placeDescriptionTextView.delegate = self
            placeDescriptionTextView.textColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 0.15)
            placeDescriptionTextView.text = "예) 녹사평역 3번 출구 맞은편."
        }
    }
    
    @IBOutlet weak var placeDescriptionHeightConstraint: NSLayoutConstraint!
    
    // MARK: - 찍은 사진 업로드 Margin View 설정
    @IBOutlet weak var pictureUploadMarginView: UIView! {
        didSet {
            pictureUploadMarginView.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
            pictureUploadMarginView.clipsToBounds = true
        }
    }
    
    private func setPictureUploadMarginLayout() {
        pictureUploadMarginView.layer.cornerRadius = pictureUploadMarginView.frame.width / 12.33
    }
    
    // MARK: - 사진 업로드 작업 설정
    private var picker: UIImagePickerController?

    private func setPickerController() {
        picker?.delegate = self
    }
    
    @IBAction func uploadPicture(_ sender: Any) {
        picker = UIImagePickerController()
        picker?.delegate = self
        openLibrary()
    }
    
    private func openLibrary() {
        picker?.sourceType = .photoLibrary
        guard let picker = self.picker else { return }
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - 업로드 사진 UIImageView
    @IBOutlet weak var photoImageView: UIImageView!
    
    // MARK: - 이미지 삭제 버튼
    @IBOutlet weak var deleteButton: UIButton! {
        didSet {
            deleteButton.isHidden = true
        }
    }
    
    @IBAction func deletePicture(_ sender: Any) {
        deleteButton.isHidden = true
        photoImageView.image = nil
    }
    
    // MARK: - 완료 버튼 설정
    @IBOutlet weak var completeButton: CustomButton! {
        didSet {
            completeButton.locationButton = .reportView
        }
    }
    
    // MARK: - UIViewController viewDidLoad 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setPickerController()
    }
    
    // MARK: - UIViewController viewWillAppear 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    // MARK: - UIViewController viewDidLayoutSubviews 설정
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setPictureUploadMarginLayout()
    }
}

extension ReportVC {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension ReportVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 0.15) {
            textView.text = nil
            textView.textColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1.0)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "예) 녹사평역 3번 출구 맞은편."
            placeDescriptionTextView.textColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 0.15)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeDescriptionHeightConstraint.constant = placeDescriptionTextView.intrinsicContentSize.height
        
        guard let text = textView.text else { return }
        let layerColor: UIColor = text != "" ? .grapefruit : .veryLightPink
        marginViews[2].layer.borderColor = layerColor.cgColor
    }
}

extension ReportVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let layerColor: UIColor = text != "" ? .grapefruit : .veryLightPink
        
        if textField == textFields[0] {
            marginViews[0].layer.borderColor = layerColor.cgColor
        } else if textField == textFields[1] {
            marginViews[1].layer.borderColor = layerColor.cgColor
        } else {
            marginViews[3].layer.borderColor = layerColor.cgColor
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textFields[1] {
            textField.resignFirstResponder()
            guard let searchAddressVC = UIStoryboard(name: "SearchAddress", bundle: nil).instantiateViewController(withIdentifier: SearchAddressVC.identifier) as? SearchAddressVC else { return }
            self.navigationController?.pushViewController(searchAddressVC, animated: true)
        }
    }
}

extension ReportVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.image = image
            deleteButton.isHidden = false
            self.dismiss(animated: true, completion: nil)
        }
    }
}
