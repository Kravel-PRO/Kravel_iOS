//
//  AuthorizationPopupVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/08.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class AuthorizationPopupVC: UIViewController {
    static let identifier = "AuthorizationVC"
    
    enum AuthorType {
        case camera
        case gallery
        case location
        
        func getAuthorImage() -> UIImage? {
            switch self {
            case .camera: return UIImage(named: ImageKey.icPhoto)
            case .gallery: return UIImage(named: ImageKey.noAccessGallery)
            case .location: return UIImage(named: ImageKey.noAccessLocation)
            }
        }
    }
    
    private var author: AuthorType?
    
    func setAuthorType(author: AuthorType) {
        self.author = author
    }
    
    // MARK: - Completion Handler
    var completionHandler: (() -> Void)?
    var cancelHandler: (() -> Void)?

    // MARK: - 아이콘 이미지 설정
    @IBOutlet weak var icImageView: UIImageView!
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    
    private func setImageViewLayout() {
        imageTopConstraint.constant = -(icImageView.frame.height * 0.84)
    }
    
    // MARK: - 팝업 배경화면 설정
    @IBOutlet weak var popupView: UIView! {
        didSet {
            popupView.makeShadow(color: UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 0.7), blur: 20, x: 3, y: 3)
            popupView.clipsToBounds = false
        }
    }
    
    private func setPopupViewLayout() {
        popupView.layer.cornerRadius = popupView.frame.width / 31.5
    }
    
    // MARK: - 제목 라벨 설정
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    func setPopupText(title: String?, message: String?) {
        titleLabel.text = title
        titleLabel.invalidateIntrinsicContentSize()
        
        messageLabel.text = message
        messageLabel.invalidateIntrinsicContentSize()
    }
    
    // MARK: - 버튼들 설정
    @IBOutlet var buttons: [CustomButton]! {
        didSet {
            buttons.forEach {
                $0.locationButton = .logoutPopupView
            }
        }
    }
    
    private func setButtonsLayout() {
        buttons.forEach {
            $0.layer.cornerRadius = $0.frame.width / 5.9
            $0.clipsToBounds = true
        }
    }
    
    // 취소 버튼 눌렀을 때, Dismiss
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        cancelHandler?()
    }
    
    // 설정화면으로 이동
    @IBAction func allow(_ sender: Any) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:]) { isComplection in
            self.dismiss(animated: false, completion: nil)
        }
        completionHandler?()
    }
    
    // MARK: - 카메라 허용 뒷 배경
    @IBOutlet weak var authorBackView: UIView! {
        didSet {
            authorBackView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var cameraImageTopConstraint: NSLayoutConstraint!
    
    private func setAuthorizationViewLayout() {
        cameraImageTopConstraint.constant = authorBackView.frame.height / 5.5
        authorBackView.layer.cornerRadius = authorBackView.frame.width / 55.4
    }
    
    // MARK: - 권한 허용 대표 icon
    @IBOutlet weak var authorImageView: UIImageView!
    
    // MARK: - 카메라 권한 허용 Label
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorMessageLabel: UILabel!
    
    // MARK: - UIViewController viewDidLoad 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setAuthorView()
    }
    
    private func setAuthorView() {
        buttons[0].setTitle("허용 안함".localized, for: .normal)
        buttons[1].setTitle("허용".localized, for: .normal)
        titleLabel.text = "앱 접근 권한 허용".localized
        messageLabel.text = "서비스를 이용하기 위해\n아래와 같은 권한을 허용해주세요.".localized
        
        switch author {
        case .camera:
            authorImageView.image = self.author?.getAuthorImage()
            authorLabel.text = "카메라".localized
            authorMessageLabel.text = "- " + "사진 촬영".localized
        case .gallery:
            authorImageView.image = self.author?.getAuthorImage()
            authorLabel.text = "사진/파일".localized
            authorMessageLabel.text = "- " + "사진 자동 저장 및 포토리뷰 업로드".localized
        case .location:
            authorImageView.image = self.author?.getAuthorImage()
            authorLabel.text = "위치 정보".localized
            authorMessageLabel.text = "- " + "GPS 이용 및 지도 검색".localized
        case .none: break
        }
    }
    
    // MARK: - UIViewController viewDidLayoutSubviews 설정
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setImageViewLayout()
        setPopupViewLayout()
        setButtonsLayout()
        setAuthorizationViewLayout()
    }
}
