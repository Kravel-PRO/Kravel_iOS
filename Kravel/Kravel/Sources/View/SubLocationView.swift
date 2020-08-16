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
