//
//  MapVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/21.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit
import NMapsMap

class MapVC: UIViewController {
    // MARK: - MapView 설정
    @IBOutlet weak var containerMapView: UIView!
    
    lazy var mapView: NMFMapView = {
        let map = NMFMapView(frame: containerMapView.frame)
        map.positionMode = .direction
        return map
    }()
    
    private func setMapView() {
        containerMapView.addSubview(mapView)
        mapView.addCameraDelegate(delegate: self)
        overlay = mapView.locationOverlay
        overlay?.hidden = false
    }
    
    // MARK: - 마커 데이터 설정
    private var allPlaceData: [PlaceContentInform] = []
    private var markers: [NMFMarker] = []
    
    private let icMarkDefault = NMFOverlayImage(name: ImageKey.icMarkDefault)
    private let icMarkFocus = NMFOverlayImage(name: ImageKey.icMarkFocus)
    
    // 선택된 마커 ID
    private var selectedMarkerID: Int = -1
    
    lazy var markerTouchHandler: (NMFOverlay) -> Bool = { [weak self] marker in
        guard let self = self else { return true }
        if let isTouch = marker.userInfo["isTouch"] as? Bool,
            let selectID = marker.userInfo["id"] as? Int,
            let castingMarker = marker as? NMFMarker {
            castingMarker.iconImage = isTouch ? self.icMarkDefault : self.icMarkFocus
            marker.userInfo["isTouch"] = !isTouch
            
            // 선택된 Marker에 따라 현재 뷰의 상태 업데이트
            if !isTouch {
                self.placeShadowView.isHidden = false
                self.nearPlaceCollectionView.isHidden = true
                self.placePopupView.showingState = .halfShow
                self.placePopupView.setEnableScroll(false)
                
                self.requestPhotoReview(of: selectID)
                self.requestDetailPlaceData(of: selectID)
                
                NSLayoutConstraint.activate([self.anotherConstraint])
                NSLayoutConstraint.deactivate([self.currentLocationButtonBottomConstraint])
                
                UIView.animate(withDuration: 0.3) {
                    self.placeShadowView.transform = CGAffineTransform(translationX: 0, y: -self.calculateInitPanelViewHeight())
                }
            } else {
                self.placeShadowView.isHidden = true
                self.nearPlaceCollectionView.isHidden = false
                self.placePopupView.showingState = .notShow
                
                NSLayoutConstraint.activate([self.currentLocationButtonBottomConstraint])
                NSLayoutConstraint.deactivate([self.anotherConstraint])
                
                self.placeShadowView.transform = .identity
            }
            
            // 초기 상태인 경우 선택된 값이 1도 없는 경우
            if self.selectedMarkerID == -1 {
                self.selectedMarkerID = selectID
                return true
            }
            
            // 선택된 아이디가 같은 경우는 터치 상태만 바꾸어주기
            guard selectID != self.selectedMarkerID else { return true }
            
            let preMarkers = self.markers.filter { $0.userInfo["id"] as! Int == self.selectedMarkerID }
            guard preMarkers.count == 1, let preMarker = preMarkers.first else {
                print("Logic Error")
                return true
            }
            
            // 이전에 선택된 마커를 새로운게 선택되었기 때문에, 바꾸어주는 로직
            preMarker.iconImage = self.icMarkDefault
            preMarker.userInfo["isTouch"] = false
        
            self.selectedMarkerID = selectID
        }
        return true
    }
    
    private func makeMarker(placeID: Int, latitude: Double, longitude: Double) -> NMFMarker {
        let marker = NMFMarker(position: NMGLatLng(lat: latitude, lng: longitude))
        marker.iconImage = icMarkDefault
        marker.userInfo = ["id": placeID, "isTouch": false]
        marker.touchHandler = self.markerTouchHandler
        return marker
    }
    
    // MARK: - 내 위치 기준 새로고침 설정
    var refreshButton: UIButton = {
        let refreshButton = UIButton()
        refreshButton.setImage(UIImage(named: ImageKey.icRefresh), for: .normal)
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.makeShadow(color: UIColor.black.withAlphaComponent(0.3), blur: 4, x: 0, y: 2)
       return refreshButton
    }()
    
    // 1. 리프레쉬 버튼에 타겟 추가
    // 2. 리프레쉬 버튼 화면에 추가
    private func setRefreshButton() {
        refreshButton.addTarget(self, action: #selector(refresh(_:)), for: .touchUpInside)
        self.view.addSubview(refreshButton)
    }
    
    @objc func refresh(_ sender: Any) {
        // 근처 관광지 받아오는 API 통신
        print("Refresh")
    }
    
    private func setRefreshButtonLayout() {
        NSLayoutConstraint.activate([
            refreshButton.leadingAnchor.constraint(equalTo: currentLocationButton.leadingAnchor),
            refreshButton.trailingAnchor.constraint(equalTo: currentLocationButton.trailingAnchor),
            refreshButton.bottomAnchor.constraint(equalTo: currentLocationButton.topAnchor, constant: -16),
            refreshButton.widthAnchor.constraint(equalTo: currentLocationButton.widthAnchor),
            refreshButton.heightAnchor.constraint(equalTo: currentLocationButton.heightAnchor)
        ])
    }
    
    // MARK: - 현재 내위치 찾기 설정
    var overlay: NMFLocationOverlay?
    
    var currentLocationButton: UIButton = {
        let currentLocationButton = UIButton()
        currentLocationButton.setImage(UIImage(named: ImageKey.icGPS), for: .normal)
        currentLocationButton.makeShadow(color: UIColor.black.withAlphaComponent(0.3), blur: 4, x: 0, y: 2)
        currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        return currentLocationButton
    }()
    
    private func setCurrentLocationButton() {
        currentLocationButton.addTarget(self, action: #selector(searchLocation(_:)), for: .touchUpInside)
        self.view.addSubview(currentLocationButton)
    }

    // 내 위치 찾아오기 Core Location 설정
    private func setLocationManager() {
        LocationManager.shared.requestAuthorization()
    }
    
    // 카메라를 현재 Overlay 위치로 옮겨주는 코드
    private func setMapCameraMyLocation() {
        guard let overlay = self.overlay else { return }
        let cameraUpdate = NMFCameraUpdate(scrollTo: overlay.location)
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate) { isCompletion in
            self.mapView.positionMode = .direction
        }
    }
    
    // 내 위치 찾기 버튼 눌렀을 때
    @objc func searchLocation(_ sender: Any) {
        if mapView.positionMode == .direction {
            mapView.positionMode = .normal
            currentLocationButton.setImage(UIImage(named: ImageKey.icGPSInActive), for: .normal)
        } else {
            setMapCameraMyLocation()
            currentLocationButton.setImage(UIImage(named: ImageKey.icGPS), for: .normal)
        }
    }
    
    // 내 위치 찾기 버튼 바뀔 때마다 Bottom Constraint 바꾸어주기
    var currentLocationButtonBottomConstraint: NSLayoutConstraint!
    var anotherConstraint: NSLayoutConstraint!
    
    // 내 위치 찾기 버튼 초기 화면 설정
    private func setCurrentLocationButtonLayout() {
        currentLocationButtonBottomConstraint = currentLocationButton.bottomAnchor.constraint(equalTo: nearPlaceCollectionView.topAnchor, constant: -16)
        anotherConstraint = self.currentLocationButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16-self.calculateInitPanelViewHeight())
    
        NSLayoutConstraint.activate([
            currentLocationButtonBottomConstraint,
            currentLocationButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            currentLocationButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.12),
            currentLocationButton.heightAnchor.constraint(equalTo: currentLocationButton.widthAnchor, multiplier: 1)
        ])
    }
    
    // MARK: - 가까운 곳 나타내는 CollectionView 초기화
    @IBOutlet weak var nearPlaceCollectionView: UICollectionView! {
        didSet {
            nearPlaceCollectionView.dataSource = self
            nearPlaceCollectionView.delegate = self
            nearPlaceCollectionView.showsHorizontalScrollIndicator = false
            nearPlaceCollectionView.showsVerticalScrollIndicator = false
        }
    }
    
    private var nearPlaces: [String] = ["정재네 집", "호준이네 집", "유나네 집", "혜선이네 집", "경선이네 집", "수연이네 집", "세림이네 집"]
    
    // MARK: - Floating Panel View
    lazy var placePopupView: PlacePopupView = {
        // PopupView 초기 위치 설정
        let tempPopupView = PlacePopupView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        tempPopupView.showingState = .notShow
        tempPopupView.translatesAutoresizingMaskIntoConstraints = false
        return tempPopupView
    }()
    
    // Shadow을 표현하기 위해 바깥 View
    lazy var placeShadowView: UIView = {
        let estimateY = calculatePanelViewY()
        let shadowView = UIView(frame: CGRect(x: 0, y: estimateY, width: view.frame.width, height: view.frame.height))
        shadowView.makeShadow(color: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1), blur: 4, x: 0, y: -2)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.isHidden = true
        return shadowView
    }()
    
    private func calculatePanelViewY() -> CGFloat {
        let tabbarHeight = self.tabBarController!.tabBar.frame.height
        return self.view.frame.height - calculateInitPanelViewHeight() - tabbarHeight
    }
    
    private func calculateInitPanelViewHeight() -> CGFloat {
        let indicatorViewHeight = self.view.frame.width * 8 / 125
        let imageHeight = self.view.frame.width * 0.22
        let spacing: CGFloat = 18
        let tabbarHeight = self.tabBarController!.tabBar.frame.height
        return indicatorViewHeight + imageHeight + spacing + tabbarHeight
    }
    
    private func calculateBottomInset() -> CGFloat {
        let spacingHeight = self.view.frame.height - calculateInitPanelViewHeight() - 400
        return spacingHeight
    }
    
    // 새로운 장소 클릭했을 때, 뜨는 화면
    private func showPlacePopupView() {
        addGesture()
        self.view.addSubview(placeShadowView)
        placeShadowView.addSubview(placePopupView)
        setPopupViewLayout()
        placePopupView.contentScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: calculateBottomInset(), right: 0)
    }
    
    // 새로운 장소 클릭했을 때, PopupView 지우기
    private func hidePlacePopupView() {
        placeShadowView.removeGestureRecognizer(panGesuture)
        placeShadowView.removeFromSuperview()
        placePopupView.removeFromSuperview()
    }
    
    // Popup View AutoLayout 지정
    private func setPopupViewLayout() {
        NSLayoutConstraint.activate([
            placeShadowView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            placeShadowView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            placeShadowView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            placeShadowView.topAnchor.constraint(equalTo: self.view.bottomAnchor),
            placePopupView.topAnchor.constraint(equalTo: placeShadowView.topAnchor),
            placePopupView.leadingAnchor.constraint(equalTo: placeShadowView.leadingAnchor),
            placePopupView.trailingAnchor.constraint(equalTo: placeShadowView.trailingAnchor),
            placePopupView.bottomAnchor.constraint(equalTo: placeShadowView.bottomAnchor)
        ])
    }
    
    // PopupView PanGesture 구현
    var panGesuture: UIPanGestureRecognizer!
    
    private var isPanning: Bool = false
    
    private func addGesture() {
        panGesuture = UIPanGestureRecognizer(target: self, action: #selector(movePanelView(_:)))
        placeShadowView.addGestureRecognizer(panGesuture)

    }
    
    // Pan Action에 따라 뷰 Interaction
    @objc func movePanelView(_ sender: Any) {
        let transition = panGesuture.translation(in: placeShadowView)
        let changeY = transition.y + placeShadowView.transform.ty
        placeShadowView.transform = CGAffineTransform(translationX: 0, y: changeY)
        panGesuture.setTranslation(.zero, in: placeShadowView)
        
        if panGesuture.state == .ended {
            guard let showingState = placePopupView.showingState else { return }
            switch showingState {
            case .notShow: return
            case .halfShow:
                if -calculateInitPanelViewHeight() - changeY > (self.view.frame.height / 16.9) {
                    placePopupView.showingState = .almostShow
                    placePopupView.setEnableScroll(true)
                    UIView.animate(withDuration: 0.3) {
                        self.placeShadowView.transform = CGAffineTransform(translationX: 0, y: -400-self.calculateInitPanelViewHeight())
                    }
                } else {
                    UIView.animate(withDuration: 0.3) {
                        self.placeShadowView.transform = CGAffineTransform(translationX: 0, y: -self.calculateInitPanelViewHeight())
                    }
                }
            case .almostShow:
                if -400 - calculateInitPanelViewHeight() - changeY <= -(self.view.frame.height / 16.9) {
                    placePopupView.showingState = .halfShow
                    placePopupView.setEnableScroll(false)
                    placePopupView.contentScrollView.contentOffset = .zero
                    UIView.animate(withDuration: 0.3) {
                        self.placeShadowView.transform = CGAffineTransform(translationX: 0, y: -self.calculateInitPanelViewHeight())
                    }
                } else if  -400 - calculateInitPanelViewHeight() - changeY > -(self.view.frame.height / 16.9) && -400 - calculateInitPanelViewHeight() - changeY < (self.view.frame.height / 16.9) {
                    UIView.animate(withDuration: 0.3) {
                        self.placeShadowView.transform = CGAffineTransform(translationX: 0, y: -400-self.calculateInitPanelViewHeight())
                    }
                } else {
                    placePopupView.showingState = .allShow
                    UIView.animate(withDuration: 0.3, animations: {
                        self.placeShadowView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
                    }, completion: { isComplete in
                        guard let locationDetailRootVC = UIStoryboard(name: "LocationDetail", bundle: nil).instantiateViewController(withIdentifier: "LocationDetailRoot") as? UINavigationController else { return }
                        locationDetailRootVC.modalPresentationStyle = .overFullScreen
                        guard let locationDetailVC = locationDetailRootVC.topViewController as? LocationDetailVC else { return }
                        locationDetailVC.placeID = self.selectedMarkerID
                        
                        self.present(locationDetailRootVC, animated: false
                            , completion: {
                                self.placeShadowView.isHidden = true
                                self.placeShadowView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
                                self.placePopupView.contentScrollView.contentOffset = .zero
                        })
                    })
                }
            case .allShow: return
            }
        }
    }
    
    // MARK: - UIViewController viewDidLoad override 부분
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addObserver()
        setLocationManager()
        setMapView()
        setCurrentLocationButton()
        setRefreshButton()
        showPlacePopupView()
        requestAllPlaceData()
        setCurrentLocationButtonLayout()
    }
    
    // MARK: - 지도 표시 위한 장소 가져오는 API 요청
    private func requestAllPlaceData() {
        let getPlaceParameter = GetPlaceParameter(latitude: nil, longitude: nil, page: nil, size: 100, review_count: nil, sort: nil)
        NetworkHandler.shared.requestAPI(apiCategory: .getPlace(getPlaceParameter)) { result in
            switch result {
            case .success(let getPlaceResult):
                guard let getPlaceResult = getPlaceResult as? APISortableResponseData<PlaceContentInform> else { return }
                self.allPlaceData = getPlaceResult.content
                self.allPlaceData.forEach { placeData in
                    let marker = self.makeMarker(placeID: placeData.placeId, latitude: placeData.latitude, longitude: placeData.longitude)
                    self.markers.append(marker)
                }
            
                DispatchQueue.main.async {
                    // FIXME: - 마커 찍는 코드 넣기
                    self.markers.forEach { marker in
                        marker.mapView = self.mapView
                    }
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
    
    // MARK: - 선택한 장소 ID Detail 정보 가져오기
    private func requestDetailPlaceData(of placeID: Int) {
        NetworkHandler.shared.requestAPI(apiCategory: .getPlaceOfID(placeID)) { result in
            switch result {
            case .success(let detailInform):
                guard let detailInform = detailInform as? PlaceDetailInform else { return }
                DispatchQueue.main.async {
                    self.setDetailPlaceData(detailInform)
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
    
    // MARK: - 마커 눌렀을 시, 팝업 뷰에 데이터 설정
    // Issue - 데이터를 내가 전부 가지고 있다가 Client에서 설정할 지 서버에서 id로 요청할지
    private func setDetailPlaceData(_ detailInform: PlaceDetailInform) {
        placePopupView.placeName = detailInform.title
        placePopupView.placeTags = detailInform.tags
        placePopupView.placeLocation = detailInform.location
        placePopupView.subLocationContainerView.setMarker(latitude: detailInform.latitude, longitude: detailInform.longitude, iconImage: icMarkDefault)
        placePopupView.subLocationContainerView.location = detailInform.location
        placePopupView.subLocationContainerView.busDatas = detailInform.bus
        placePopupView.subLocationContainerView.subwayDatas = detailInform.subway
        placePopupView.subLocationContainerView.busDescription = "버스"
        placePopupView.subLocationContainerView.subwayDescription = "지하철"
        // FIXME: 이미지 받아오기 수정
//        placePopupView.placeImage = detailInform.imageUrl
    }
    
    // MARK: - 선택한 장소 Photo Review 가져오기
    private func requestPhotoReview(of placeID: Int) {
        let getPlaceReviewParameter = GetReviewOfPlaceParameter(latitude: nil, longitude: nil, like_count: nil)
        APICostants.placeID = "\(placeID)"
        
        NetworkHandler.shared.requestAPI(apiCategory: .getPlaceReview(getPlaceReviewParameter)) { result in
            switch result {
            case .success(let placeReviewData):
                guard let placeReviewData = placeReviewData as? APISortableResponseData<ReviewInform> else { return }
                print("리뷰 데이터: \(placeReviewData)")
                DispatchQueue.main.async {
                    self.placePopupView.photoReviewData = placeReviewData.content
                }
            case .requestErr(let error):
                print(error)
                DispatchQueue.main.async {
                    self.placePopupView.photoReviewData = []
                }
            case .serverErr: print("Server Err")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
    
    // MARK: - UIViewController viewWillAppear override 부분
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - UIViewController viewWillLayoutSubviews override 부분
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setRefreshButtonLayout()
    }
}

extension MapVC {
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(scrollDownView(_:)), name: .dismissDetailView, object: nil)
    }
    
    @objc func scrollDownView(_ notification: NSNotification) {
        placeShadowView.isHidden = false
        placePopupView.showingState = .halfShow
        placePopupView.setEnableScroll(false)
        UIView.animate(withDuration: 0.2) {
            self.placeShadowView.transform = CGAffineTransform(translationX: 0, y: -self.calculateInitPanelViewHeight())
        }
    }
}

extension MapVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearPlaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let nearPlaceCell = collectionView.dequeueReusableCell(withReuseIdentifier: NearPlaceCell.identifier, for: indexPath) as? NearPlaceCell else { return UICollectionViewCell() }
        nearPlaceCell.backgroundColor = .clear
        
        nearPlaceCell.contentView.layer.cornerRadius = nearPlaceCell.contentView.frame.width / 49.6
        nearPlaceCell.contentView.clipsToBounds = true
        
        nearPlaceCell.makeShadow(color: UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 0.13), blur: 10, x: 3, y: 2)
        nearPlaceCell.clipsToBounds = false
        
        // 여기 Image Name 데이터로 받아오면 설정해야함
        nearPlaceCell.placeImage = UIImage(named: "bitmap_1")
        nearPlaceCell.placeName = nearPlaces[indexPath.row]
        nearPlaceCell.location = "서울 종로구 돈화문로11길 28-5 (낙원동)"
        return nearPlaceCell
    }
}

extension MapVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height * 1.3, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.frame.width / 31.25
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension MapVC: UICollectionViewDelegate {
}

extension MapVC: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        if reason == -1 {
            currentLocationButton.setImage(UIImage(named: ImageKey.icGPSInActive), for: .normal)
        }
    }
}
