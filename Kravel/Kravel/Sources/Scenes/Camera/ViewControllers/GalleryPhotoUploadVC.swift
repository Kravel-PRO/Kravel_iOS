//
//  GalleryPhotoUploadVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/09/30.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit

class GalleryPhotoUploadVC: UIViewController {
    static let identifier = "GalleryPhotoUploadVC"
    
    var placeId: Int?
    
    // MARK: - 데이터 로딩 중 Lottie 화면
    private var loadingView: UIActivityIndicatorView?
    
    private func showLoadingLottie() {
        loadingView = UIActivityIndicatorView(style: .large)
        self.view.addSubview(loadingView!)
        loadingView?.center = self.view.center
        loadingView?.startAnimating()
    }
    
    private func stopLottieAnimation() {
        loadingView?.stopAnimating()
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
    
    // MARK: - 사진 앨범 UIImageView
    @IBOutlet weak var photoImageView: UIImageView! {
        didSet {
            guard let photoImage = selectedImage[ImageDictionaryKey.img.rawValue] as? UIImage else { return }
            self.photoImageView.image = photoImage
        }
    }
    
    var selectedImage: [String: Any] = [:]
    
    // MARK: - 포토리뷰 작성 버튼
    @IBOutlet weak var writeReviewButton: CustomButton! {
        didSet {
            writeReviewButton.locationButton = .galleryUploadPhotoView
            writeReviewButton.setTitle("리뷰 쓰기".localized, for: .normal)
        }
    }
    
    @IBAction func upload(_ sender: Any) {
        showLoadingLottie()
        guard let placeId = self.placeId else { return }
        APIConstants.placeID = "\(placeId)"
        
        NetworkHandler.shared.requestAPI(apiCategory: .postPlaceReview(selectedImage)) { result in
            switch result {
            case .success(let uploadResult):
                guard let uploadResult = uploadResult as? Int else { return }
                if uploadResult == 200 {
                    DispatchQueue.main.async {
                        self.stopLottieAnimation()
                        self.navigationController?.popViewController(animated: true)
                        NotificationCenter.default.post(name: .completeUpload, object: nil)
                    }
                }
            case .requestErr: break
            case .serverErr:
                print("Server Error")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
    
    
    // MARK: - UIViewController viewDidLoad Override 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UIViewController viewWillAppear Override 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    private func setNav() {
        self.navigationItem.title = ""
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.isHidden = false
        let backImage = UIImage(named: ImageKey.back)
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationBar.tintColor = .black
    }
}
