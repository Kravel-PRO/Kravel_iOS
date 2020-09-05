//
//  LocationDetailVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/14.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit
import Lottie
import NMapsMap

class LocationDetailVC: UIViewController {
    static let identifier = "LocationDetailVC"
    
    // 선택된 장소 ID
    var placeID: Int?
    
    // MARK: - 화면 Dismiss 해주는 Pan Gesture
    var panGesture: UIPanGestureRecognizer!
    
    // MARK: - 데이터 로딩 중 Lottie 화면
    private var animationView: AnimationView?
    
    private func showLoadingLottie() {
        animationView = AnimationView(name: "loading_map")
        animationView?.backgroundColor = .white
        animationView?.contentMode = .scaleAspectFit
        animationView?.frame = self.view.bounds
        animationView?.play()
        
        self.view.addSubview(animationView!)
    }
    
    func stopLottieAnimation() {
        animationView?.removeFromSuperview()
        animationView = nil
    }
    
    // MARK: - 전체 Content 나타내는 ScrollView
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    // MARK: - 뒤로 가기 버튼 설정
    @IBOutlet weak var backButtonTopConstraint: NSLayoutConstraint!
    
    private func setBackButtonConstraint() {
        backButtonTopConstraint.constant = self.view.safeAreaInsets.top
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - 장소 이미지 설정
    @IBOutlet weak var placeImageView: UIImageView!
    
    var placeImage: UIImage? {
        didSet {
            placeImageView.image = placeImage
        }
    }
    
    // MARK: - 장소 이름 Label 설정
    @IBOutlet weak var placeNameLabel: UILabel!
    
    var placeName: String? {
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
    
    var placeTags: [String] = [] {
        didSet {
            tagCollectionView.reloadData()
        }
    }
    
    // MARK: - 장소 위치 Label 설정
    @IBOutlet weak var placeLocationLabel: UILabel!
    
    var location: String? {
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
    
    // 사진 화면으로 이동
    @IBAction func takePicture(_ sender: Any) {
        guard let cameraVC = UIStoryboard(name: "Camera", bundle: nil).instantiateViewController(withIdentifier: CameraVC.identifier) as? CameraVC else { return }
        cameraVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(cameraVC, animated: true)
    }
    
    private var isScrap: Bool = false
    
    // 스크랩하기 버튼
    @IBAction func scrap(_ sender: Any) {
        guard let scrapButton = sender as? UIButton else { return }
        
        isScrap = !isScrap
        let scrapButtonImage = isScrap ? UIImage(named: ImageKey.icScrapFill) : UIImage(named: ImageKey.icScrap)
        scrapButton.setImage(scrapButtonImage, for: .normal)
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
        let photoReviewAttributeText = "포토 리뷰".makeAttributedText([.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1.0)])
        photoReviewView.attributeTitle = photoReviewAttributeText
    }
    
    private func setPhotoReviewViewLayout() {
        let defaultHeight: CGFloat = 48
        let horizontalSpacing = view.frame.width / 23.44
        let cellHeight: CGFloat = (photoReviewView.frame.width - horizontalSpacing*2 - 4*2) / 3
        if photoReviewData.count == 0 { photoReviewViewHeightConstraint.constant = defaultHeight }
        else if photoReviewData.count <= 3 { photoReviewViewHeightConstraint.constant = defaultHeight + cellHeight + 16 }
        else { photoReviewViewHeightConstraint.constant = defaultHeight + 2 * cellHeight + 16 }
    }
    
    // MARK: - 위치 정보 나타내는 뷰 설정
    @IBOutlet weak var subLocationView: SubLocationView!
    
    // MARK: - 내 주변 관광지 뷰 설정
    @IBOutlet weak var nearByAttractionView: NearByAttractionView!
    
    // MARK: - UIViewController viewDidLoad() Override 부분
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addGesture()
        showLoadingLottie()
        if let placeID = self.placeID {
            requestDetailPlaceData(of: placeID)
            requestPhotoReview(of: placeID)
        }
    }
    
    // MARK: - 장소 ID로부터 Detail 정보 가져오기
    private func requestDetailPlaceData(of placeID: Int) {
        NetworkHandler.shared.requestAPI(apiCategory: .getPlaceOfID(placeID)) { result in
            switch result {
            case .success(let detailInform):
                guard let detailInform = detailInform as? PlaceDetailInform else { return }
                DispatchQueue.main.async {
                    self.setDetailPlaceData(detailInform)
                    self.stopLottieAnimation()
                }
            case .requestErr(let error):
                print(error)
            case .serverErr: print("Server Err")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
    
    private func setDetailPlaceData(_ detailInform: PlaceDetailInform) {
        placeName = detailInform.title
        placeTags = detailInform.tags
        location = detailInform.location
        subLocationView.busDescription = "버스"
        subLocationView.busDatas = detailInform.bus
        subLocationView.subwayDescription = "지하철"
        subLocationView.subwayDatas = detailInform.subway
        subLocationView.location = detailInform.location
        subLocationView.setMarker(latitude: detailInform.latitude, longitude: detailInform.longitude, iconImage: NMFOverlayImage(name: ImageKey.icMarkDefault))
        
        // FIXME: Image URL로부터 가져오기 수정
//        placeImage = detailInform.imageUrl
    }
    
    // MARK: - 장소 ID로부터 포토 리뷰 가져오기
    private func requestPhotoReview(of placeID: Int) {
        let getPlaceReviewParameter = GetReviewOfPlaceParameter(latitude: nil, longitude: nil, like_count: nil)
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
    
    // MARK: - UIViewController viewWillLayoutSubviews() Override 부분
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setBackButtonConstraint()
    }
    
    // MARK: - UIViewController viewWillAppear() Override 부분
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    private func setNav() {
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension LocationDetailVC: PhotoReviewViewDelegate {
    func clickWriteButton() {
        guard let photoReviewUploadVC = UIStoryboard(name: "PhotoReviewUpload", bundle: nil).instantiateViewController(withIdentifier: PhotoReviewUploadVC.identifier) as? PhotoReviewUploadVC else { return }
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
        
        photoReviewCell.photoImage = UIImage(named: "yuna2")
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
        if indexPath.row == 5 {
            guard let otherPhotoReviewVC = UIStoryboard(name: "OtherPhotoReview", bundle: nil).instantiateViewController(withIdentifier: OtherPhotoReviewVC.identifier) as? OtherPhotoReviewVC else { return }
            self.navigationController?.pushViewController(otherPhotoReviewVC, animated: true)
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
            NotificationCenter.default.post(name: .dismissDetailView, object: nil)
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
