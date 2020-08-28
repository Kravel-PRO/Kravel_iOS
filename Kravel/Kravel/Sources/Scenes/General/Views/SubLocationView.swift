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
    @IBOutlet weak var locationDescriptionLabel: UILabel!
    
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
        return map
    }()
    
    // Map View 추가
    private func setMapView() {
        containerMapView.addSubview(mapView)
    }
    
    // MARK: - 주소 표시하는 Label 설정
    @IBOutlet weak var locationLabel: UILabel!
    
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
    @IBOutlet weak var busDescriptionLabel: UILabel!
    
    var busDescription: String? {
        didSet {
            busDescriptionLabel.text = busDescription
        }
    }
    
    // MARK: - 지하철을 설명해주는 Label
    @IBOutlet weak var subwayDescriptionLabel: UILabel!
    
    var subwayDescription: String? {
        didSet {
            subwayDescriptionLabel.text = subwayDescription
            let size = subwayDescriptionLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            subwayDescriptionWidthConstraint.constant = size.width
        }
    }
    
    @IBOutlet weak var subwayDescriptionWidthConstraint: NSLayoutConstraint!
    
    // MARK: - 버스로 가는 방법을 알려주는 Label
    @IBOutlet weak var busesLabel: UILabel!
    
    var busDatas: [String] = [] {
        didSet {
            busesLabel.text = busDatas.joined(separator: ", ")
            busesLabel.sizeToFit()
        }
    }
    
    // MARK: - 지하철로 가는 방법을 알려주는 Label
    @IBOutlet weak var subwaysLabel: UILabel!
    
    var subwayDatas: [String] = [] {
        didSet {
            subwaysLabel.text = subwayDatas.joined(separator: ", ")
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
