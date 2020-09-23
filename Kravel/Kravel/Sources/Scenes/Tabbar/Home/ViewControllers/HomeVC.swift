//
//  HomeVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/13.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit
import CoreLocation
import Lottie

class HomeVC: UIViewController {
    private var activityIndicator: UIActivityIndicatorView?
    private var isLoadingComplete: [Bool] = [false, false]
    private var isRefreshComplete: [Bool] = [false, false, false]
    
    @IBOutlet weak var contentScrollView: UIScrollView! {
        didSet {
            contentScrollView.delegate = self
        }
    }
    
    @IBOutlet weak var contentInsetView: UIView! {
        didSet {
            contentInsetView.backgroundColor = .grapefruit
        }
    }
    
    // MARK: - 제일 위 Title View 설정
    @IBOutlet weak var titleStackView: UIStackView! {
        didSet {
            titleStackView.arrangedSubviews.forEach { element in
                element.backgroundColor = .grapefruit
            }
            titleStackView.arrangedSubviews[1].isHidden = true
        }
    }
    
    // Title Label 설정
    @IBOutlet weak var titleLabel: UILabel!
    
    // 나와 가까운 Kravel 소개 Label
    @IBOutlet weak var closerLabel: UILabel!
    
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
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var emptyView: UIView! {
        didSet {
            emptyView.isHidden = true
        }
    }
    @IBOutlet weak var hotPlaceLabel: UILabel!
    
    @IBOutlet weak var hotPlaceCollectionViewHeightConstraint: NSLayoutConstraint!
    
    // 인기있는 장소 CollectionView 설정
    private func setHotPlaceCollectionViewHeight() {
        let horizontalSpacing = view.frame.width / 23.44
        let lineSpacing: CGFloat = 12
        let cellWidth = hotPlaceCollectionView.frame.width - 2*horizontalSpacing
        let cellHeight = cellWidth * 0.46
        if hotPlaceData.count == 0 {
            emptyView.isHidden = false
            hotPlaceCollectionView.isHidden = true
        } else {
            emptyView.isHidden = true
            hotPlaceCollectionView.isHidden = false
        }
        hotPlaceCollectionViewHeightConstraint.constant = cellHeight * CGFloat(hotPlaceData.count) + lineSpacing * CGFloat((hotPlaceData.count-1))
        
        self.view.layoutIfNeeded()
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
        if photoReviewData.count == 0 {
            photoReviewViewHeightConstraint.constant = defaultHeight + 35 + 75
            photoReviewView.photoReviewEmptyView.isHidden = false
            photoReviewView.photoReviewCollectionView.isHidden = true
        } else if photoReviewData.count <= 3 {
            photoReviewViewHeightConstraint.constant = defaultHeight + cellHeight
            photoReviewView.photoReviewEmptyView.isHidden = true
            photoReviewView.photoReviewCollectionView.isHidden = false
        } else {
            photoReviewViewHeightConstraint.constant = defaultHeight + 2 * cellHeight + 4
            photoReviewView.calculateCollectionViewHeight()
            photoReviewView.photoReviewEmptyView.isHidden = true
            photoReviewView.photoReviewCollectionView.isHidden = false
        }
    }
    
    // 포토리뷰 보여주는 데이터
    private var photoReviewData: [ReviewInform] = []
    
    private func setPhotoReviewLabelLayout() {
        let horizontalSpacing = view.frame.width / 23.44
        photoReviewView.photoReviewCollectionViewLeadingConstraint.constant = horizontalSpacing
    }
    
    // MARK: - UIViewController viewDidLoad Override
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setRefreshView()
        startIndicatorView()
        requestLocation()
        addObserver()
        setLabelByLanguage()
        
        requestReviewData {
            // 로딩화면 처리하기 위한 표시
            self.isLoadingComplete[1] = true
            if self.isLoadingComplete.filter({ !$0 }).isEmpty {
                self.stopIndicatorView()
            }
        }
        
        requestHotPlaceData {
            // 로딩화면 처리하기 위한 표시
            self.isLoadingComplete[0] = true
            if self.isLoadingComplete.filter({ !$0 }).isEmpty {
                self.stopIndicatorView()
            }
        }
    }
    
    private func setLabelByLanguage() {
        let attributeTitle = "당신의 한국 여행을\n더 특별하게,\nKravel만의 장소를 둘러보세요.".localized.makeAttributedText([.font: UIFont.boldSystemFont(ofSize: 24), .foregroundColor: UIColor.white])
        attributeTitle.addAttributes([.font: UIFont(name: "AppleSDGothicNeo-Light", size: 24.0)!], range: ("당신의 한국 여행을\n더 특별하게,\nKravel만의 장소를 둘러보세요.".localized as NSString).range(of: "Kravel만의 장소를 둘러보세요.".localized))
        titleLabel.attributedText = attributeTitle
        
        let attributeClose = "나와 가까운 Kravel".localized.makeAttributedText([.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor.white])
        attributeClose.addAttributes([.font: UIFont.systemFont(ofSize: 18)], range: ("나와 가까운 Kravel".localized as NSString).range(of: "나와 가까운".localized))
        closerLabel.attributedText = attributeClose
        
        moreButton.setTitle("더 보기".localized, for: .normal)
        
        let attributePhotoReview = "새로운 포토 리뷰".localized.makeAttributedText([.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1.0)])
        attributePhotoReview.addAttributes([.font: UIFont.boldSystemFont(ofSize: 18)], range: ("새로운 포토 리뷰".localized as NSString).range(of: "포토 리뷰".localized))
        photoReviewView.attributeTitle = attributePhotoReview
        
        let attributeHotPlace = "요즘 여기가 인기 있어요!".localized.makeAttributedText([.font: UIFont.boldSystemFont(ofSize: 18)])
        attributeHotPlace.addAttributes([.font: UIFont.systemFont(ofSize: 18)], range: ("요즘 여기가 인기 있어요!".localized as NSString).range(of: "인기 있어요!".localized))
        hotPlaceLabel.attributedText = attributeHotPlace
        emptyLabel.text = "조금만 기다려주세요!\n특별한 장소를 찾아올게요!".localized
    }
    
    // MARK: - 서버 로딩 중 띄어지는 Loading 화면
    private func startIndicatorView() {
        self.activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.center = self.view.center
        activityIndicator?.startAnimating()
        guard let indicator = self.activityIndicator else { return }
        self.view.addSubview(indicator)
    }

    private func stopIndicatorView() {
        self.activityIndicator?.stopAnimating()
        self.activityIndicator?.removeFromSuperview()
        self.activityIndicator = nil
    }
    
    // MARK: - 홈 리로딩 중 띄어지는 Loading 화면
    private func setRefreshView() {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .grapefruit
        refreshControl.tintColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        refreshControl.addTarget(self, action: #selector(reloadAllDatas), for: .valueChanged)
        contentScrollView.refreshControl = refreshControl
    }
    
    @objc func reloadAllDatas() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            isRefreshComplete[0] = true
            break
        case .notDetermined:
            isRefreshComplete[0] = true
            break
        case .authorizedWhenInUse:
            requestLocation()
        case .restricted:
            isRefreshComplete[0] = true
            break
        case .denied:
            isRefreshComplete[0] = true
            break
        @unknown default:
            isRefreshComplete[0] = true
            break
        }
        
        requestHotPlaceData {
            self.isRefreshComplete[1] = true
            if self.isRefreshComplete.filter({ !$0 }).isEmpty {
                self.stopRefresh()
            }
        }
        
        requestReviewData {
            self.isRefreshComplete[2] = true
            if self.isRefreshComplete.filter({ !$0 }).isEmpty {
                self.stopRefresh()
            }
        }
    }
    
    private func stopRefresh() {
        for index in 0..<isRefreshComplete.count {
            isRefreshComplete[index] = false
        }
        contentScrollView.refreshControl?.endRefreshing()
    }
    
    // MARK: - UIViewController viewWillAppear Override
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    // MARK: - UIViewController viewDidAppear Override
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setNav() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - UIViewController viewDidLayoutSubviews Override
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setPhotoReviewViewLayout()
    }
}

extension HomeVC {
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(setLanguage(_:)), name: .changeLanguage, object: nil)
    }
    
    @objc func setLanguage(_ notification: NSNotification) {
        setLabelByLanguage()
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
                
                self.isRefreshComplete[0] = true
                if self.isRefreshComplete.filter({ !$0 }).isEmpty {
                    self.stopRefresh()
                }
                
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
    private func requestHotPlaceData(loadingCompletion: @escaping () -> Void) {
        let getPlaceParameter = GetPlaceParameter(latitude: nil, longitude: nil, page: nil, size: 5, review_count: nil, sort: "review-count,desc")
        NetworkHandler.shared.requestAPI(apiCategory: .getPlace(getPlaceParameter)) { result in
            switch result {
            case .success(let getPlaceResult):
                guard let getPlaceResult = getPlaceResult as? APISortableResponseData<PlaceContentInform> else { return }
                self.hotPlaceData = getPlaceResult.content
                
                // 로딩화면 처리하기 위한 표시
                loadingCompletion()
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
    private func requestReviewData(loadingCompletion: @escaping () -> Void) {
        let getReviewParameter = GetReviewParameter(page: 0, size: 6, sort: "createdDate,desc")
        NetworkHandler.shared.requestAPI(apiCategory: .getReview(getReviewParameter)) { result in
            switch result {
            case .success(let getReviewResult):
                guard let getReviewResult = getReviewResult as? APISortableResponseData<ReviewInform> else { return }
                self.photoReviewData = getReviewResult.content
                
                // 로딩화면 처리하기 위한 표시
                loadingCompletion()
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
        case .authorizedWhenInUse:
            LocationManager.shared.setManager(delegate: self)
            LocationManager.shared.requestLocation()
        case .authorizedAlways:
            break
        case .notDetermined:
            LocationManager.shared.requestAuthorization()
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
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // FIXME: 이거 AppDelegate에 설정해서 앱 시작할 때 물어야할 듯 -> 시간 나면 고치기
        guard let location = locations.first else { return }
        currentLocation = location.coordinate
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
        if let tags = nearPlaceData[indexPath.row].tags {
            homeNearPlaceCell.tags = tags.split(separator: ",").map({ String($0) })
        } else {
            homeNearPlaceCell.tags = []
        }
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
        
        if let tags = hotPlaceData[indexPath.row].tags {
            hotPlaceCell.tags = tags.split(separator: ",").map({ String($0) })
        } else {
            hotPlaceCell.tags = []
        }
        
        hotPlaceCell.photoCount = hotPlaceData[indexPath.row].reviewCount
        hotPlaceCell.placeImageView.setImage(with: hotPlaceData[indexPath.row].imageUrl ?? "")
        
        return hotPlaceCell
    }
    
    // MARK: - 포토리뷰 보여주는 Cell 생성
    private func makePhotoReviewCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> PhotoReviewCell {
        guard let photoReviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoReviewCell.identifier, for: indexPath) as? PhotoReviewCell else { return PhotoReviewCell() }
        
        photoReviewCell.photoImageView.setImage(with: photoReviewData[indexPath.row].imageUrl ?? "")
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
