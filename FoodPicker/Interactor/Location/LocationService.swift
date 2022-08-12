//
//  LocaionHandler.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/7.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

enum LoactionError: Error {
  case locationNotFound
}

class LocationService: NSObject {
    static let shared = LocationService()
    
    var locationManager : CLLocationManager = {
        let lm = CLLocationManager()
        lm.desiredAccuracy = kCLLocationAccuracyBest
        return lm
    }()

    var coordinate: CLLocationCoordinate2D? {
      return self.locationManager.location?.coordinate
    }
    
    func enableLocationServices(){
        locationManager.delegate = self
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }
}
//MARK: - CLLocationManagerDelegate
extension LocationService : CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
}
