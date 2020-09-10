//
//  HomeVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/13.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit
import CoreLocation

class HomeVC: UIViewController {
    // MARK: - 제일 위 Title View 설정
    @IBOutlet weak var titleStackView: UIStackView! {
        didSet {
            titleStackView.arrangedSubviews[1].isHidden = true
        }
    }
    
    // Title Label 설정
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            let attributeTitle = "색다른 여행을 만들어 줄\nKravel 장소가\n준비되어 있어요!".makeAttributedText([.font: UIFont.boldSystemFont(ofSize: 24), .foregroundColor: UIColor.white])
            attributeTitle.addAttributes([.font: UIFont(name: "AppleSDGothicNeo-Light", size: 24.0)!], range: ("색다른 여행을 만들어 줄\nKravel 장소가\n준비되어 있어요!" as NSString).range(of: "색다른 여행을 만들어 줄"))
            titleLabel.attributedText = attributeTitle
            titleLabel.sizeToFit()
        }
    }
    
    // 나와 가까운 Kravel 소개 Label
    @IBOutlet weak var closerLabel: UILabel! {
        didSet {
            let attributeTitle = "나와 가까운 Kravel".makeAttributedText([.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor.white])
            attributeTitle.addAttributes([.font: UIFont.systemFont(ofSize: 18)], range: ("나와 가까운 Kravel" as NSString).range(of: "Kravel"))
            closerLabel.attributedText = attributeTitle
            closerLabel.sizeToFit()
        }
    }
    
    // 더 보기 버튼 이미지, Label 위치 변경
    @IBOutlet weak var moreButton: UIButton! {
        didSet {
            moreButton.transform = CGAffineTransform(scaleX: -1, y: 1)
            moreButton.titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
            moreButton.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    // 더 보기 버튼 클릭했을 시, 더 많은 장소 요청
    @IBAction func requstMorePlace(_ sender: Any) {
        guard let detailNearPlaceVC = UIStoryboard(name: "NearPlace", bundle: nil).instantiateViewController(withIdentifier: NearPlaceVC.identifier) as? NearPlaceVC else { return }
        detailNearPlaceVC.currentLocation = currentLocation
        detailNearPlaceVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailNearPlaceVC, animated: true)
    }
    
    // MARK: - 가까운 장소 CollectionView 설정
    private var nearPlaceData: [PlaceContentInform] = []
    
    @IBOutlet weak var nearPlaceCollectionView: UICollectionView! {
        didSet {
            nearPlaceCollectionView.dataSource = self
            nearPlaceCollectionView.delegate = self
        }
    }
    
    private var currentLocation: CLLocationCoordinate2D? {
        didSet {
            guard let currentLocation = currentLocation else { return }
            requestClosePlaceData(lat: currentLocation.latitude, lng: currentLocation.longitude)
        }
    }
    
    // 근처 지역 데이터 보여주는 화면 데이터 있을 시, 없을 시 세팅
    private func setNearPlaceCollectionView() {
        if nearPlaceData.isEmpty { titleStackView.arrangedSubviews[1].isHidden = true }
        else {
            titleStackView.arrangedSubviews[1].isHidden = false
            nearPlaceCollectionView.reloadData()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - 인기 있는 장소 설정
    @IBOutlet weak var hotPlaceLabel: UILabel! {
        didSet {
            let attributeHotPlaceText = "요즘 여기가 인기 있어요!".makeAttributedText([.font: UIFont.boldSystemFont(ofSize: 18)])
            attributeHotPlaceText.addAttributes([.font: UIFont.systemFont(ofSize: 18)], range: ("요즘 여기가 인기 있어요!" as NSString).range(of: "요즘 여기가"))
            hotPlaceLabel.attributedText = attributeHotPlaceText
            hotPlaceLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var hotPlaceLabelLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var hotPlaceCollectionViewHeightConstraint: NSLayoutConstraint!
    
    // 인기있는 장소 CollectionView 설정
    private func setHotPlaceCollectionViewHeight() {
        let horizontalSpacing = view.frame.width / 23.44
        let lineSpacing: CGFloat = 12
        let cellWidth = hotPlaceCollectionView.frame.width - 2*horizontalSpacing
        let cellHeight = cellWidth * 0.46
        hotPlaceCollectionViewHeightConstraint.constant = cellHeight * CGFloat(hotPlaceData.count) + lineSpacing * CGFloat((hotPlaceData.count-1))
    }
    
    private func setHotPlaceLabelLayout() {
        let hotPlaceSize = hotPlaceLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        hotPlaceLabel.heightAnchor.constraint(equalToConstant: hotPlaceSize.height).isActive = true
        hotPlaceLabelLeadingConstraint.constant = view.frame.width / 23.44
    }
    
    private var hotPlaceData: [PlaceContentInform] = []
    
    @IBOutlet weak var hotPlaceCollectionView: UICollectionView! {
        didSet {
            hotPlaceCollectionView.dataSource = self
            hotPlaceCollectionView.delegate = self
        }
    }
    
    // MARK: - 포토 리뷰 뷰 설정
    @IBOutlet weak var photoReviewView: PhotoReviewView! {
        didSet {
            setPhotoReviewLabel()
            photoReviewView.photoReviewCollectionViewDelegate = self
            photoReviewView.photoReviewCollectionViewDataSource = self
            photoReviewView.writeButton.isHidden = true
        }
    }
    
    @IBOutlet weak var photoReviewViewHeightConstraint: NSLayoutConstraint!
    
    private func setPhotoReviewViewLayout() {
        let defaultHeight: CGFloat = 48
        let horizontalSpacing = view.frame.width / 23.44
        let cellHeight: CGFloat = (photoReviewView.frame.width - horizontalSpacing*2 - 4*2) / 3
        if photoReviewData.count == 0 { photoReviewViewHeightConstraint.constant = defaultHeight }
        else if photoReviewData.count <= 3 { photoReviewViewHeightConstraint.constant = defaultHeight + cellHeight }
        else { photoReviewViewHeightConstraint.constant = defaultHeight + 2 * cellHeight }
    }
    
    // 포토리뷰 보여주는 데이터
    private var photoReviewData: [ReviewInform] = []
    
    private func setPhotoReviewLabel() {
        let photoReviewAttributeText = "인기 많은 포토 리뷰".makeAttributedText([.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1.0)])
        photoReviewAttributeText.addAttributes([.font: UIFont.boldSystemFont(ofSize: 18)], range: ("인기 많은 포토 리뷰" as NSString).range(of: "포토 리뷰"))
        photoReviewView.attributeTitle = photoReviewAttributeText
    }
    
    private func setPhotoReviewLabelLayout() {
        let horizontalSpacing = view.frame.width / 23.44
        photoReviewView.photoReviewCollectionViewLeadingConstraint.constant = horizontalSpacing
    }
    
    // MARK: - UIViewController viewDidLoad Override
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UIViewController viewWillAppear Override
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
        requestLocation()
        requestReviewData()
        requestHotPlaceData()
    }
    
    private func setNav() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - UIViewController viewDidLayoutSubviews Override
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setHotPlaceCollectionViewHeight()
        setHotPlaceLabelLayout()
        setPhotoReviewLabelLayout()
        setPhotoReviewViewLayout()
    }
}

extension HomeVC {
    // MARK: - 장소 데이터 API 요청
    private func requestClosePlaceData(lat: Double, lng: Double) {
        let getPlaceParameter = GetPlaceParameter(latitude: lat, longitude: lng, page: nil, size: nil, review_count: nil, sort: nil)
        NetworkHandler.shared.requestAPI(apiCategory: .getPlace(getPlaceParameter)) { result in
            switch result {
            case .success(let getPlaceResult):
                guard let getPlaceResult = getPlaceResult as? APISortableResponseData<PlaceContentInform> else { return }
                self.nearPlaceData = getPlaceResult.content
                DispatchQueue.main.async {
                    self.setNearPlaceCollectionView()
                }
            case .requestErr(let errorMessage):
                print(errorMessage)
            case .serverErr:
                print("ServerError")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
    
    // MARK: - 인기 장소 데이터 API 요청
    private func requestHotPlaceData() {
    // FIXME: - 이거 나중에 데이터 받아오게 하기
//        let getPlaceParameter = GetPlaceParameter(latitude: nil, longitude: nil, page: nil, size: 5, review_count: false, sort: "review-count,asc")
        let getPlaceParameter = GetPlaceParameter(latitude: nil, longitude: nil, page: nil, size: 5, review_count: true, sort: nil)
        NetworkHandler.shared.requestAPI(apiCategory: .getPlace(getPlaceParameter)) { result in
            switch result {
            case .success(let getPlaceResult):
                guard let getPlaceResult = getPlaceResult as? APISortableResponseData<PlaceContentInform> else { return }
                self.hotPlaceData = getPlaceResult.content
                DispatchQueue.main.async {
                    self.setHotPlaceCollectionViewHeight()
                    self.hotPlaceCollectionView.reloadData()
                }
            case .requestErr(let errorMessage):
                print(errorMessage)
            case .serverErr:
                print("ServerError")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
    
    // MARK: - 포토리뷰 데이터 API 요청
    private func requestReviewData() {
        let getReviewParameter = GetReviewParameter(page: 0, size: 6, sort: "reviewLikes-count,desc")
        NetworkHandler.shared.requestAPI(apiCategory: .getNewReview(getReviewParameter)) { result in
            switch result {
            case .success(let getReviewResult):
                guard let getReviewResult = getReviewResult as? APISortableResponseData<ReviewInform> else { return }
                self.photoReviewData = getReviewResult.content
                DispatchQueue.main.async {
                    self.setPhotoReviewViewLayout()
                    self.photoReviewView.photoReviewCollectionView.reloadData()
                }
            case .requestErr(let errorMessage):
                print(errorMessage)
            case .serverErr:
                print("ServerError")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
}

extension HomeVC: CLLocationManagerDelegate {
    // MARK: - 위치 관련 설정
    private func requestLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            guard let authorizationVC = UIStoryboard(name: "AuthorizationPopup", bundle: nil).instantiateViewController(withIdentifier: AuthorizationPopupVC.identifier) as? AuthorizationPopupVC else { return }
            authorizationVC.setAuthorType(author: .location)
            authorizationVC.modalPresentationStyle = .overFullScreen
            self.present(authorizationVC, animated: false, completion: nil)
        case .restricted:
            guard let authorizationVC = UIStoryboard(name: "AuthorizationPopup", bundle: nil).instantiateViewController(withIdentifier: AuthorizationPopupVC.identifier) as? AuthorizationPopupVC else { return }
            authorizationVC.setAuthorType(author: .location)
            authorizationVC.modalPresentationStyle = .overFullScreen
            self.present(authorizationVC, animated: false, completion: nil)
        case .denied:
            guard let authorizationVC = UIStoryboard(name: "AuthorizationPopup", bundle: nil).instantiateViewController(withIdentifier: AuthorizationPopupVC.identifier) as? AuthorizationPopupVC else { return }
            authorizationVC.setAuthorType(author: .location)
            authorizationVC.modalPresentationStyle = .overFullScreen
            self.present(authorizationVC, animated: false, completion: nil)
        case .authorizedWhenInUse:
            LocationManager.shared.setManager(delegate: self)
            LocationManager.shared.requestLocation()
        case .authorizedAlways: break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // FIXME: 이거 AppDelegate에 설정해서 앱 시작할 때 물어야할 듯 -> 시간 나면 고치기
        guard let location = locations.first else { return }
        self.currentLocation = CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0)
//        currentLocation = location.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find User Location \(error.localizedDescription)")
    }
}

extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == nearPlaceCollectionView { return nearPlaceData.count }
        else if collectionView == hotPlaceCollectionView { return hotPlaceData.count }
        else { return photoReviewData.count }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == nearPlaceCollectionView { return makeNearPlaceCell(collectionView, indexPath) }
        else if collectionView == hotPlaceCollectionView { return makeHotPlaceCell(collectionView, indexPath) }
        else { return makePhotoReviewCell(collectionView, indexPath) }
    }
    
    // MARK: - 가까운 장소 보여주는 Cell 생성
    private func makeNearPlaceCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> HomeNearPlaceCell {
        guard let homeNearPlaceCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeNearPlaceCell.identifier, for: indexPath) as? HomeNearPlaceCell else { return HomeNearPlaceCell() }

        homeNearPlaceCell.placeName = nearPlaceData[indexPath.row].title
        homeNearPlaceCell.tags = nearPlaceData[indexPath.row].tags ?? []
        homeNearPlaceCell.placeImageView.setImage(with: nearPlaceData[indexPath.row].imageUrl ?? "")
        
        homeNearPlaceCell.layer.cornerRadius = homeNearPlaceCell.frame.width / 15.9
        homeNearPlaceCell.clipsToBounds = true
        return homeNearPlaceCell
    }
    
    // MARK: - 인기있는 장소 보여주는 Cell 생성
    private func makeHotPlaceCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> HotPlaceCell {
        guard let hotPlaceCell = collectionView.dequeueReusableCell(withReuseIdentifier: HotPlaceCell.identifier, for: indexPath) as? HotPlaceCell else { return HotPlaceCell() }
        hotPlaceCell.layer.cornerRadius = hotPlaceCell.frame.width / 17.15
        hotPlaceCell.clipsToBounds = true
        
        hotPlaceCell.location = hotPlaceData[indexPath.row].title
        hotPlaceCell.tags = hotPlaceData[indexPath.row].tags ?? []
        hotPlaceCell.photoCount = hotPlaceData[indexPath.row].reviewCount
        hotPlaceCell.placeImageView.setImage(with: hotPlaceData[indexPath.row].imageUrl ?? "")
        
        return hotPlaceCell
    }
    
    // MARK: - 포토리뷰 보여주는 Cell 생성
    private func makePhotoReviewCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> PhotoReviewCell {
        guard let photoReviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoReviewCell.identifier, for: indexPath) as? PhotoReviewCell else { return PhotoReviewCell() }

        photoReviewCell.photoImageView.setImage(with: photoReviewData[indexPath.row].imageURl)
        if indexPath.row == 5 { photoReviewCell.addMoreView() }
        return photoReviewCell
    }
}

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == nearPlaceCollectionView {
            touchNearPlaceCell(at: indexPath)
        } else if collectionView == hotPlaceCollectionView {
            touchHotPlaceCell(at: indexPath)
        } else {
            touchPhotoCell(at: indexPath)
        }
    }
    
    private func touchNearPlaceCell(at indexPath: IndexPath) {
        guard let locationDetailVC = UIStoryboard(name: "LocationDetail", bundle: nil).instantiateViewController(withIdentifier: LocationDetailVC.identifier) as? LocationDetailVC else { return }
        print(nearPlaceData[indexPath.row].placeId)
        locationDetailVC.placeID = nearPlaceData[indexPath.row].placeId
        locationDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(locationDetailVC, animated: true)
    }
    
    private func touchHotPlaceCell(at indexPath: IndexPath) {
        guard let locationDetailVC = UIStoryboard(name: "LocationDetail", bundle: nil).instantiateViewController(withIdentifier: LocationDetailVC.identifier) as? LocationDetailVC else { return }
        locationDetailVC.placeID = hotPlaceData[indexPath.row].placeId
        locationDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(locationDetailVC, animated: true)
    }
    
    private func touchPhotoCell(at indexPath: IndexPath) {
        // FIXME: 여기 클릭된 ID 넘겨주고 하는 코드 추가해야할 듯.
        guard let morePhotoVC = UIStoryboard(name: "MorePhotoReview", bundle: nil).instantiateViewController(withIdentifier: MorePhotoReviewVC.identifier) as? MorePhotoReviewVC else { return }
        morePhotoVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(morePhotoVC, animated: true)
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == nearPlaceCollectionView {
            let width = collectionView.frame.height * 0.9
            return CGSize(width: width, height: collectionView.frame.height)
        } else if collectionView == hotPlaceCollectionView {
            let horizontalSpacing = view.frame.width / 23.44
            let cellWidth = collectionView.frame.width - 2*horizontalSpacing
            let cellHeight = cellWidth * 0.46
            return CGSize(width: cellWidth, height: cellHeight)
        } else {
            let horizontalSpacing = view.frame.width / 23.44
            let cellWidth = (collectionView.frame.width - horizontalSpacing*2 - 4*2) / 3
            return CGSize(width: cellWidth, height: cellWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let horizontalSpacing = view.frame.width / 23.44
        return UIEdgeInsets(top: 0, left: horizontalSpacing, bottom: 0, right: horizontalSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == nearPlaceCollectionView || collectionView == hotPlaceCollectionView {
            return 10
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == nearPlaceCollectionView || collectionView == hotPlaceCollectionView {
            return 0
        } else {
            return 4
        }
    }
}
