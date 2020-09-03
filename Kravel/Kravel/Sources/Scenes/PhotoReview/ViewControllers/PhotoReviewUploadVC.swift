//
//  PhotoReviewUploadVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/29.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class PhotoReviewUploadVC: UIViewController {
    static let identifier = "PhotoReviewUploadVC"
    
    // MARK: - UIImagePickerController 설정
    private var picker: UIImagePickerController?
    
    private func setPickerController() {
        picker = UIImagePickerController()
        picker?.delegate = self
    }
    
    // MARK: - 사진 올리기 Margin View 설정
    @IBOutlet weak var pictureUploadMarginView: UIView! {
        didSet {
            pictureUploadMarginView.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
            pictureUploadMarginView.clipsToBounds = true
        }
    }
    
    // MARK: - 가져온 사진 Image View 설정
    @IBOutlet weak var photoImageView: UIImageView!
    
    // MARK: - 업로드 사진 삭제 버튼
    @IBOutlet weak var pictureDeleteButton: UIButton! {
        didSet {
            pictureDeleteButton.isHidden = true
        }
    }
    
    @IBAction func deletePicture(_ sender: Any) {
        photoImageView.image = nil
        pictureDeleteButton.isHidden = true
    }
    
    // MARK: - 사진 업로드 버튼
    @IBAction func clickPictureUpload(_ sender: Any) {
        openLibrary()
    }
    
    private func openLibrary() {
        if let picker = self.picker {
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
        }
    }
    
    // MARK: - 완성 버튼 설정
    @IBOutlet weak var completeButton: CustomButton! {
        didSet {
            completeButton.locationButton = .signupView
        }
    }
    
    // MARK: - UIViewController viewDidLoad Override 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setPickerController()
    }
    
    // MARK: - UIViewController viewWillAppear Override 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    private func setNav() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "포토 리뷰 올리기"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .black
    }
}

extension PhotoReviewUploadVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.image = image
            pictureDeleteButton.isHidden = false
            self.dismiss(animated: true, completion: nil)
        }
    }
}

