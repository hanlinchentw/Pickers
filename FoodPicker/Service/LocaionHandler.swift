//
//  LocaionHandler.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/7.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import CoreLocation

class LocationHandler : NSObject {
    public static let shared = LocationHandler()
    
    private var locationManager : CLLocationManager = {
        let lm = CLLocationManager()
        lm.desiredAccuracy = kCLLocationAccuracyBest
        
        return lm
    }()
    
    var currentLocation : CLLocationCoordinate2D?
    func enableLocationServices(){
        locationManager.delegate = self
        guard let location = locationManager.location?.coordinate else { return }
        currentLocation = location
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
            print("DEBUG: AUTH always...")
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        }
    }
}
//MARK: - CLLocationManagerDelegate
extension LocationHandler : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("DEBUG: \(locations[0])")
    }
}
