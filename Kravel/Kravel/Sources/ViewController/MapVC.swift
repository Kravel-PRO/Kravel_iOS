//
//  MapVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/21.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit
import TMapSDK


class MapVC: UIViewController {
    // FIXME: - Naver MAP으로 바꾸어야 할듯..
    
    // MARK: - MapView 설정
    @IBOutlet weak var containerMapView: UIView!
    
    lazy var mapView: TMapView = {
        let map = TMapView(frame: containerMapView.frame)
        map.delegate = self
        map.setApiKey(PrivateKey.tmapAPIKey)
        return map
    }()
    
    private func setMapView() {
        containerMapView.addSubview(mapView)
    }
    
    // MARK: - 현재 내위치 찾기 설정
    var currentLocationButton: UIButton = {
        let currentLocationButton = UIButton()
        currentLocationButton.setImage(UIImage(named: ImageKey.icGPSInActive), for: .normal)
        currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        return currentLocationButton
    }()
    
    private func setCurrentLocationButton() {
        currentLocationButton.addTarget(self, action: #selector(searchLocation(_:)), for: .touchUpInside)
        self.view.addSubview(currentLocationButton)
    }
    
    // 현재 위치
    private var currentLocation: CLLocationCoordinate2D?
    private var isTrackingLocation: Bool = false
    
    // 내 위치 찾아오기 Core Location 설정
    private func setLocationManager() {
        LocationManager.shared.requestAuthorization()
        LocationManager.shared.setManager(delegate: self, accuracy: kCLLocationAccuracyBest)
        LocationManager.shared.startTracking()
    }
    
    // 내 위치 찾기 버튼 눌렀을 때
    @objc func searchLocation(_ sender: Any) {
        isTrackingLocation = isTrackingLocation ? false : true
        if isTrackingLocation {
            if let currentLocation = self.currentLocation { mapView.setCenter(currentLocation) }
            currentLocationButton.setImage(UIImage(named: ImageKey.icGPS), for: .normal)
        } else {
            currentLocationButton.setImage(UIImage(named: ImageKey.icGPSInActive), for: .normal)
        }
    }
    
    private var currentLocationMarker: TMapMarker?
    
    private func makeMarker(location: CLLocationCoordinate2D) {
        currentLocationMarker = TMapMarker()
        currentLocationMarker?.position = location
        currentLocationMarker?.title = "제목없음"
        currentLocationMarker?.map = self.mapView
    }
    
    // 내 위치 찾기 버튼 바뀔 때마다 Bottom Constraint 바꾸어주기
    var currentLocationButtonBottomConstraint: NSLayoutConstraint!
    
    // 내 위치 찾기 버튼 초기 화면 설정
    private func setCurrentLocationButtonLayout() {
        currentLocationButtonBottomConstraint = currentLocationButton.bottomAnchor.constraint(equalTo: placeShadowView.topAnchor, constant: -16)
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
            
            nearPlaceCollectionView.isHidden = true
        }
    }
    
    private var nearPlaces: [String] = ["정재네 집", "호준이네 집", "유나네 집", "혜선이네 집", "경선이네 집", "수연이네 집", "세림이네 집"]
    
    // MARK: - Floating Panel View
    lazy var placePopupView: PlacePopupView = {
        // PopupView 초기 위치 설정
        let tempPopupView = PlacePopupView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        tempPopupView.translatesAutoresizingMaskIntoConstraints = false
        return tempPopupView
    }()
    
    // Shadow을 표현하기 위해 바깥 View
    lazy var placeShadowView: UIView = {
        let estimateY = calculatePanelViewY()
        let shadowView = UIView(frame: CGRect(x: 0, y: estimateY, width: view.frame.width, height: view.frame.height))
        shadowView.makeShadow(color: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1), blur: 4, x: 0, y: -2)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
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
        
        // 임시로 설정 - 나중에 장소 눌렀을 때 설정될 수 있게 바꾸기
        placePopupView.placeImage = UIImage(named: "back")
        placePopupView.placeName = "호텔 세느장"
        placePopupView.placeLocation = "서울 종로구 돈화문로11길 28-5 (낙원동)"
    }
    
    // 새로운 장소 클릭했을 때, PopupView 지우기
    private func hidePlacePopupView() {
        placeShadowView.removeGestureRecognizer(panGesuture)
        placeShadowView.removeFromSuperview()
        placePopupView.removeFromSuperview()
    }
    
    // POPUp View AutoLayout 지정
    private func setPopupViewLayout() {
        NSLayoutConstraint.activate([
            placeShadowView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            placeShadowView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            placeShadowView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            placeShadowView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -calculateInitPanelViewHeight()),
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
            if !isPanning, changeY < -(self.view.frame.height / 16.9) {
                isPanning = true
                placePopupView.setEnableScroll(true)
                UIView.animate(withDuration: 0.3) {
                    self.placeShadowView.transform = CGAffineTransform(translationX: 0, y: -400)
                }
            } else if !isPanning, changeY >= -(self.view.frame.height / 16.9) {
                UIView.animate(withDuration: 0.3) {
                    self.placeShadowView.transform = .identity
                }
            } else if isPanning, -400 - changeY <= -(self.view.frame.height / 16.9) {
                isPanning = false
                placePopupView.setEnableScroll(false)
                placePopupView.contentScrollView.contentOffset = .zero
                UIView.animate(withDuration: 0.3) {
                    self.placeShadowView.transform = .identity
                }
            } else if isPanning, -400 - changeY > -(self.view.frame.height / 16.9) &&
                -400 - changeY < (self.view.frame.height / 16.9) {
                UIView.animate(withDuration: 0.3) {
                    self.placeShadowView.transform = CGAffineTransform(translationX: 0, y: -400)
                }
            } else {
                let restHeight = self.view.frame.height - calculateInitPanelViewHeight() - 400
                UIView.animate(withDuration: 0.3, animations: {
                    self.placeShadowView.transform = CGAffineTransform(translationX: 0, y: -400-restHeight)
                }, completion: { isComplete in
                    guard let locationDetailVC = UIStoryboard(name: "LocationDetail", bundle: nil).instantiateViewController(withIdentifier: "LocationDetailVC") as? LocationDetailVC else { return }
                    locationDetailVC.modalPresentationStyle = .fullScreen
                    self.present(locationDetailVC, animated: false
                        , completion: {
                            self.placeShadowView.transform = CGAffineTransform(translationX: 0, y: -400)
                            self.placePopupView.contentScrollView.contentOffset = .zero
                    })
                })
            }
        }
    }
    
    // MARK: - ViewController Override 부분
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setLocationManager()
        setMapView()
        setCurrentLocationButton()
        showPlacePopupView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setCurrentLocationButtonLayout()
    }
}

extension MapVC: TMapViewDelegate {
    
}

extension MapVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearPlaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let nearPlaceCell = collectionView.dequeueReusableCell(withReuseIdentifier: NearPlaceCell.identifier, for: indexPath) as? NearPlaceCell else { return UICollectionViewCell() }
        
        nearPlaceCell.backgroundColor = .white
        nearPlaceCell.layer.cornerRadius = nearPlaceCell.frame.width / 49.6
        nearPlaceCell.makeShadow(color: UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 0.14), blur: 3, x: 3, y: 2)
        
        // 여기 Image Name 데이터로 받아오면 설정해야함
        nearPlaceCell.placeImage = UIImage(named: "bitmap_1")
        nearPlaceCell.placeName = nearPlaces[indexPath.row]
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

extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last?.coordinate else { return }
        self.currentLocation = currentLocation
        
//        if self.currentLocationMarker == nil { makeMarker(location: currentLocation) }
//        else { currentLocationMarker?.position = currentLocation }
        
        if isTrackingLocation {
            mapView.setCenter(currentLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
