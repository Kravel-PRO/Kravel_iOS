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
    
    // MARK: - 가까운 곳 나타내는 CollectionView 초기화
    @IBOutlet weak var nearPlaceCollectionView: UICollectionView! {
        didSet {
            nearPlaceCollectionView.dataSource = self
            nearPlaceCollectionView.delegate = self
            nearPlaceCollectionView.showsHorizontalScrollIndicator = false
            nearPlaceCollectionView.isHidden = true
        }
    }
    
    private var nearPlaces: [String] = ["정재네 집", "호준이네 집", "유나네 집", "혜선이네 집", "경선이네 집", "수연이네 집", "세림이네 집"]
    
    // MARK: - Floating Panel View
    lazy var placePopupView: PlacePopupView = {
        // PopupView 초기 위치 설정
        let indicatorViewHeight = self.view.frame.width * 8 / 125
        let imageHeight = self.view.frame.width * 0.22
        let spacing: CGFloat = 18
        let tabbarHeight = self.tabBarController!.tabBar.frame.height
        
        let estimateY = self.view.frame.height - indicatorViewHeight - imageHeight - spacing - tabbarHeight
        let tempPopupView = PlacePopupView(frame: CGRect(x: 0, y: estimateY, width: view.frame.width, height: view.frame.height))
        return tempPopupView
    }()
    
    private func setPlacePopupView() {
        self.view.addSubview(placePopupView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setMapView()
        setPlacePopupView()
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
