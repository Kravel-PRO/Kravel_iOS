//
//  SubLocationView.swift
//  Kravel
//
//  Created by 윤동민 on 2020/07/29.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit
import NMapsMap

class SubLocationView: UIView {
    static let nibName = "SubLocationView"
    var view: UIView!
    
    // MARK: - 위치를 설명해주는 Label
    @IBOutlet weak var locationDescriptionLabel: UILabel! {
        didSet {
            locationDescriptionLabel.text = "위치".localized
        }
    }
    
    var locationDescription: String? {
        didSet {
            locationDescriptionLabel.text = locationDescription
            locationDescriptionLabel.sizeToFit()
        }
    }
    
    // MARK: - Map View 설정
    @IBOutlet weak var containerMapView: UIView!
    
    lazy var mapView: NMFMapView = {
        let map = NMFMapView(frame: containerMapView.bounds)
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    // Map View 추가
    private func setMapView() {
        containerMapView.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: containerMapView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: containerMapView.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: containerMapView.bottomAnchor),
            mapView.topAnchor.constraint(equalTo: containerMapView.topAnchor)
        ])
    }
    
    // MARK: - Marker 세팅
    var marker: NMFMarker?
    
    func setMarker(latitude: Double, longitude: Double, iconImage: NMFOverlayImage) {
        marker?.mapView = nil
        let marker = NMFMarker(position: NMGLatLng(lat: latitude, lng: longitude), iconImage: iconImage)
        self.marker = marker
        marker.mapView = mapView
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude))
        cameraUpdate.animation = .none
        mapView.moveCamera(cameraUpdate)
    }
    
    // MARK: - 주소 표시하는 Label 설정
    @IBOutlet weak var locationLabel: UILabel! {
        didSet {
            locationLabel.text = " "
        }
    }
    
    var location: String? {
        didSet {
            locationLabel.text = location
            locationLabel.sizeToFit()
        }
    }
    
    // MARK: - 대중교통을 설명해주는 Label
    @IBOutlet weak var publicTransportDescriptionLabel: UILabel!
    
    var publicTransportDescription: String? {
        didSet {
            publicTransportDescriptionLabel.text = publicTransportDescription
            publicTransportDescriptionLabel.sizeToFit()
        }
    }
    
    // MARK: - 버스을 설명해주는 Label
    @IBOutlet weak var busDescriptionLabel: UILabel! {
        didSet {
            busDescriptionLabel.text = "버스".localized
        }
    }
    
    // MARK: - 지하철을 설명해주는 Label
    @IBOutlet weak var subwayDescriptionLabel: UILabel! {
        didSet {
            subwayDescriptionLabel.text = "지하철".localized
            labelWidthConstraint.constant = subwayDescriptionLabel.intrinsicContentSize.width
        }
    }
    
    @IBOutlet weak var labelWidthConstraint: NSLayoutConstraint!
    
    // MARK: - 버스로 가는 방법을 알려주는 Label
    @IBOutlet weak var busesLabel: UILabel! {
        didSet {
            busesLabel.text = "X"
        }
    }
    
    var busDatas: String? {
        didSet {
            busesLabel.text = busDatas
            busesLabel.sizeToFit()
        }
    }
    
    // MARK: - 지하철로 가는 방법을 알려주는 Label
    @IBOutlet weak var subwaysLabel: UILabel! {
        didSet {
            subwaysLabel.text = "X"
        }
    }
    
    var subwayDatas: String? {
        didSet {
            subwaysLabel.text = subwayDatas
            subwaysLabel.sizeToFit()
        }
    }
    
    // MARK: - UIView Override 부분
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
        setMapView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
        setMapView()
    }
    
    private func loadXib() {
        self.view = loadXib(from: SubLocationView.nibName)
        self.view.frame = self.bounds
        self.addSubview(view)
        self.bringSubviewToFront(view)
    }
}
