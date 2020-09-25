//
//  LocationDetailVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/14.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit
import NMapsMap
import Lottie

class LocationDetailVC: UIViewController {
    static let identifier = "LocationDetailVC"
    
    // MARK: - 선택된 장소 ID
    var placeID: Int?
    
    // MARK: - 장소 데이터
    private var placeData: PlaceDetailInform?
    
    // MARK: - 화면 Dismiss 해주는 Pan Gesture
    var panGesture: UIPanGestureRecognizer!
    
    // MARK: - 데이터 로딩 중 Lottie 화면
    private var loadingView: UIActivityIndicatorView?

    private func showLoadingLottie() {
        loadingView = UIActivityIndicatorView(style: .large)
        self.view.addSubview(loadingView!)
        loadingView?.center = self.view.center
        loadingView?.startAnimating()
    }

    func stopLottieAnimation() {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
    
    // MARK: - 전체 Content 나타내는 ScrollView
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    // MARK: - 뒤로 가기 버튼 설정
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backButtonTopConstraint: NSLayoutConstraint!
    
    /*
     Navigation Bar 있을 때의 설정
     1. 뒤로 가기 버튼
     2. PopViewController로 구현
     */
    private func setBackButtonByNav() {
        backButton.setImage(UIImage(named: ImageKey.navBackWhtie), for: .normal)
        backButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
    }
    
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
     Present로 화면을 띄운 경우 설정
     1. 밑으로 내리는 버튼
     2. dismiss로 화면 내리도록 변경
     */
    private func setBackButtonByPresent() {
        backButton.setImage(UIImage(named: ImageKey.navDownbtn), for: .normal)
        backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: false, completion: nil)
        if let scrap = self.placeData?.scrap {
            NotificationCenter.default.post(name: .dismissDetailView, object: nil, userInfo: ["scrap": scrap])
        }
    }
    
    // MARK: - 장소 이미지 설정
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeImageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var placeImageViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - 장소 이름 Label 설정
    @IBOutlet weak var placeNameLabel: UILabel!
    
    private var placeName: String? {
        didSet {
            placeNameLabel.text = placeName
            placeNameLabel.sizeToFit()
        }
    }
    
    // MARK: - 태그 CollectionView 설정
    @IBOutlet weak var tagCollectionView: UICollectionView! {
        didSet {
            tagCollectionView.dataSource = self
            if let layout = tagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                layout.minimumLineSpacing = 4
            }
        }
    }
    
    private var placeTags: [String] = [] {
        didSet {
            tagCollectionView.reloadData()
        }
    }
    
    // MARK: - 장소 위치 Label 설정
    @IBOutlet weak var placeLocationLabel: UILabel!
    
    private var location: String? {
        didSet {
            placeLocationLabel.text = location
            placeLocationLabel.sizeToFit()
        }
    }
    
    // MARK: - 사진 찍기 / 스크랩 버튼 담는 영역
    @IBOutlet weak var buttonStackContainerView: UIView! {
        didSet {
            buttonStackContainerView.layer.cornerRadius = buttonStackContainerView.frame.width / 20
            buttonStackContainerView.clipsToBounds = true
            buttonStackContainerView.layer.borderWidth = 1
            buttonStackContainerView.layer.borderColor = UIColor.veryLightPink.cgColor
        }
    }
    
    @IBOutlet weak var scrapButton: UIButton!
    
    // 사진 화면으로 이동
    @IBAction func takePicture(_ sender: Any) {
        guard let cameraVC = UIStoryboard(name: "Camera", bundle: nil).instantiateViewController(withIdentifier: CameraVC.identifier) as? CameraVC else { return }
        cameraVC.hidesBottomBarWhenPushed = true
        cameraVC.placeId = self.placeID
        self.navigationController?.pushViewController(cameraVC, animated: true)
    }
    
    // 스크랩하기 버튼
    @IBAction func scrap(_ sender: Any) {
        if let placeID = self.placeID {
            requestScrap(of: placeID)
        }
    }
    
    // MARK: - 포토 리뷰 뷰 설정
    @IBOutlet weak var photoReviewView: PhotoReviewView! {
        didSet {
            setPhotoReviewLabel()
            photoReviewView.delegate = self
            photoReviewView.photoReviewCollectionViewDataSource = self
            photoReviewView.photoReviewCollectionViewDelegate = self
        }
    }
    
    @IBOutlet weak var photoReviewViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - 포토 리뷰 데이터
    var photoReviewData: [ReviewInform] = [] {
        didSet {
            setPhotoReviewViewLayout()
            photoReviewView.photoReviewCollectionView.reloadData()
        }
    }
    
    private func setPhotoReviewLabel() {
        let photoReviewAttributeText = "포토 리뷰".localized.makeAttributedText([.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1.0)])
        photoReviewView.attributeTitle = photoReviewAttributeText
    }
    
    private func setPhotoReviewViewLayout() {
        let defaultHeight: CGFloat = 48
        let horizontalSpacing = view.frame.width / 23.44
        let cellHeight: CGFloat = (photoReviewView.frame.width - horizontalSpacing*2 - 4*2) / 3
        if photoReviewData.count == 0 {
            photoReviewViewHeightConstraint.constant = defaultHeight + 35 + 75
            photoReviewView.photoReviewEmptyView.isHidden = false
            photoReviewView.photoReviewCollectionView.isHidden = true
        } else if photoReviewData.count <= 3 {
            photoReviewViewHeightConstraint.constant = defaultHeight + cellHeight + 16
            photoReviewView.photoReviewEmptyView.isHidden = true
            photoReviewView.photoReviewCollectionView.isHidden = false
        } else {
            photoReviewViewHeightConstraint.constant = defaultHeight + 2 * cellHeight + 16
            photoReviewView.photoReviewEmptyView.isHidden = true
            photoReviewView.photoReviewCollectionView.isHidden = false
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - 위치 정보 나타내는 뷰 설정
    @IBOutlet weak var subLocationView: SubLocationView! {
        didSet {
            subLocationView.locationDescription = "위치".localized
        }
    }
    
    // MARK: - 내 주변 관광지 뷰 설정
    @IBOutlet weak var nearByAttractionView: NearByAttractionView! {
        didSet {
            nearByAttractionView.titleLabel.text = "주변 관광지".localized
        }
    }
    
    @IBOutlet weak var attrcationViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - UIViewController viewDidLoad() Override 부분
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addObserver()
        showLoadingLottie()
        
        if navigationController?.viewControllers[0] == self {
            addGesture()
            setBackButtonByPresent()
        } else {
            setBackButtonByNav()
            contentScrollView.delegate = self
        }
    }
    
    // MARK: - UIViewController viewWillAppear() Override 부분
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
        
        if let placeID = self.placeID {
            requestDetailPlaceData(of: placeID)
            requestPhotoReview(of: placeID)
        }
    }
    
    private func setNav() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.topItem?.title = ""
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        backButtonTopConstraint.constant = window.safeAreaInsets.top
    }
    
    var initHeight: CGFloat = 0
    // MARK: - UIViewController ViewDidLayoutSubviews Override 설정
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initHeight = placeImageView.frame.width / 207 * 133
        placeImageViewHeightConstraint.constant = placeImageView.frame.width / 207 * 133
    }
}

extension LocationDetailVC {
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(setNearAttrcation(_:)), name: .completeAttraction, object: nil)
    }
    
    @objc func setNearAttrcation(_ notification: NSNotification) {
        guard let isEmpty = notification.userInfo?["isEmpty"] as? Bool else { return }
        
        DispatchQueue.main.async {
            if isEmpty {
                self.attrcationViewHeightConstraint.constant = 52
            } else {
                self.attrcationViewHeightConstraint.constant = self.nearByAttractionView.nearByAttractionCollectionView.frame.height + 52
            }
        }
    }
}

extension LocationDetailVC {
    // MARK: - 장소 ID로부터 Detail 정보 가져오기
    private func requestDetailPlaceData(of placeID: Int) {
        NetworkHandler.shared.requestAPI(apiCategory: .getPlaceOfID(placeID)) { result in
            switch result {
            case .success(let detailInform):
                guard let detailInform = detailInform as? PlaceDetailInform else { return }
                self.placeData = detailInform
                DispatchQueue.main.async {
                    self.nearByAttractionView.requestTouristAPI(mapX: detailInform.longitude, mapY: detailInform.latitude)
                    self.setDetailPlaceData()
                    self.stopLottieAnimation()
                }
            case .requestErr(let error):
                print(error)
            case .serverErr:
                print("Server Err")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
    
    private func setDetailPlaceData() {
        if let placeData = self.placeData {
            placeName = placeData.title
            if let tags = placeData.tags {
                placeTags = tags.split(separator: ",").map({ String($0) })
            } else {
                placeTags = []
            }
            location = placeData.location
            subLocationView.busDatas = placeData.bus
            subLocationView.subwayDatas = placeData.subway
            subLocationView.location = placeData.location
            subLocationView.setMarker(latitude: placeData.latitude, longitude: placeData.longitude, iconImage: NMFOverlayImage(name: ImageKey.icMarkFocus))
            placeImageView.setImage(with: placeData.imageUrl ?? "")
            
            let scrapImage = placeData.scrap ? UIImage(named: ImageKey.icScrapFill) : UIImage(named: ImageKey.icScrap)
            scrapButton.setImage(scrapImage, for: .normal)
        }
    }
    
    // MARK: - 장소 ID로부터 포토 리뷰 가져오기
    private func requestPhotoReview(of placeID: Int) {
        let getPlaceReviewParameter = GetReviewParameter(page: 0, size: 6, sort: "createdDate,desc")
        APICostants.placeID = "\(placeID)"
        
        NetworkHandler.shared.requestAPI(apiCategory: .getPlaceReview(getPlaceReviewParameter)) { result in
            switch result {
            case .success(let placeReviewData):
                guard let placeReviewData = placeReviewData as? APISortableResponseData<ReviewInform> else { return }
                DispatchQueue.main.async {
                    self.photoReviewData = placeReviewData.content
                }
            case .requestErr(let error):
                print(error)
                DispatchQueue.main.async {
                    self.photoReviewData = []
                }
            case .serverErr: print("Server Err")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
    
    // MARK: - 스크랩 버튼 눌렀을 시, 서버에 반영
    private func requestScrap(of placeID: Int) {
        guard let placeData = self.placeData else { return }
        let scrapParameter = ScrapParameter(scrap: !placeData.scrap)
        
        NetworkHandler.shared.requestAPI(apiCategory: .scrap(scrapParameter)) { result in
            switch result {
            case .success(let scrapData):
                guard let scrapData = scrapData as? Int else { return }
                
                if scrapData == -1 {
                    self.placeData?.scrap = false
                    self.scrapButton.setImage(UIImage(named: ImageKey.icScrap), for: .normal)
                } else {
                    self.placeData?.scrap = true
                    self.scrapButton.setImage(UIImage(named: ImageKey.icScrapFill), for: .normal)
                }
            case .requestErr(let error):
                print(error)
            case .serverErr:
                print("Server Error")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
}

extension LocationDetailVC: PhotoReviewViewDelegate {
    func clickWriteButton() {
        guard let photoReviewUploadVC = UIStoryboard(name: "PhotoReviewUpload", bundle: nil).instantiateViewController(withIdentifier: PhotoReviewUploadVC.identifier) as? PhotoReviewUploadVC else { return }
        photoReviewUploadVC.placeId = placeID
        self.navigationController?.pushViewController(photoReviewUploadVC, animated: true)
    }
}

extension LocationDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagCollectionView { return placeTags.count }
        else { return photoReviewData.count }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tagCollectionView { return makeTagCell(collectionView, indexPath) }
        else { return makePhotoReviewCell(collectionView, indexPath) }
    }
    
    private func makeTagCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> BackgroundTagCell {
        guard let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: BackgroundTagCell.identifier, for: indexPath) as? BackgroundTagCell else { return BackgroundTagCell() }
        tagCell.tagTitle = "#\(placeTags[indexPath.row])"
        tagCell.layer.cornerRadius = tagCell.frame.width / 7.22
        tagCell.clipsToBounds = true
        return tagCell
    }
    
    private func makePhotoReviewCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> PhotoReviewCell {
        guard let photoReviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoReviewCell.identifier, for: indexPath) as? PhotoReviewCell else { return PhotoReviewCell() }
        
        photoReviewCell.photoImageView.setImage(with: photoReviewData[indexPath.row].imageUrl ?? "")
        if indexPath.row == 5 { photoReviewCell.addMoreView() }
        return photoReviewCell
    }
}

extension LocationDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpacing = self.view.frame.width / 23.44
        let cellWidth = (collectionView.frame.width - horizontalSpacing*2 - 4*2) / 3
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let horizontalSpacing = self.view.frame.width / 23.44
        return UIEdgeInsets(top: 0, left: horizontalSpacing, bottom: 0, right: horizontalSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

extension LocationDetailVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let otherPhotoReviewVC = UIStoryboard(name: "OtherPhotoReview", bundle: nil).instantiateViewController(withIdentifier: OtherPhotoReviewVC.identifier) as? OtherPhotoReviewVC else { return }
        
        if let placeId = self.placeID { otherPhotoReviewVC.requestType = .place(id: placeId) }
        if indexPath.row != 5 { otherPhotoReviewVC.selectedPhotoReviewID = self.photoReviewData[indexPath.row].reviewId }
        
        self.navigationController?.pushViewController(otherPhotoReviewVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            placeImageViewHeightConstraint.constant = initHeight - scrollView.contentOffset.y
            placeImageViewTopConstraint.constant = scrollView.contentOffset.y
        
            guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
            backButtonTopConstraint.constant = window.safeAreaInsets.top + scrollView.contentOffset.y
        }
    }
}

extension LocationDetailVC: UIGestureRecognizerDelegate {
    // MARK: - 화면 Dismissg하는 Pan Gesture 등록
    func addGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panningView(_:)))
        panGesture.delegate = self
        contentScrollView.addGestureRecognizer(panGesture)
    }
    
    @objc func panningView(_ gesture: UIPanGestureRecognizer) {
        let transition = gesture.translation(in: self.view)
        let changeY: CGFloat = transition.y + self.view.transform.ty
        
        if contentScrollView.contentOffset.y <= 0 {
            self.view.transform = CGAffineTransform(translationX: 0, y: changeY)
            contentScrollView.contentOffset = .zero
        }
        
        if self.view.transform.ty > 0 && contentScrollView.contentOffset.y > 0 {
            self.view.transform = CGAffineTransform(translationX: 0, y: changeY)
            contentScrollView.contentOffset = .zero
        }
        
        if self.view.transform.ty < 0 {
            self.view.transform = .identity
        }
        
        if panGesture.state == .ended && changeY > 100 {
            self.dismiss(animated: false, completion: nil)
            if let scrap = self.placeData?.scrap {
                NotificationCenter.default.post(name: .dismissDetailView, object: nil, userInfo: ["scrap": scrap])
            }
        } else if panGesture.state == .ended && changeY <= 100 {
            UIView.animate(withDuration: 0.3) {
                self.view.transform = .identity
            }
        }
        
        gesture.setTranslation(.zero, in: self.view)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
