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
    
    @IBOutlet weak var containerMapView: UIView!
    
    lazy var mapView: TMapView = {
        let map = TMapView(frame: containerMapView.frame)
        map.delegate = self
        map.setApiKey(PrivateKey.tmapAPIKey)
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setMapView()
    }
    
    private func setMapView() {
        containerMapView.addSubview(mapView)
    }
}

extension MapVC: TMapViewDelegate {
    
}
