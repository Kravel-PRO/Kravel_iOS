//
//  LocationManager.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/16.
//  Copyright © 2020 윤동민. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager {
    static let shared = LocationManager()
    
    private var locationManager = CLLocationManager()
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func setManager(delegate: CLLocationManagerDelegate, accuracy: CLLocationAccuracy) {
        locationManager.delegate = delegate
        locationManager.desiredAccuracy = accuracy
    }
    
    func startTracking() {
        locationManager.startUpdatingLocation()
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
}
