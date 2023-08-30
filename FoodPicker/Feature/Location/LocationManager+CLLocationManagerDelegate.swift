//
//  LocationManager+CLLocationManagerDelegate.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/10.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation
import CoreLocation

extension LocationManager: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
		print("\(#function) location=\(location)")
		lastLocation = location.coordinate
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if authorizationStatus == CLAuthorizationStatus.restricted,
			 authorizationStatus == CLAuthorizationStatus.denied {
			self.status = .stopped
		} else if authorizationStatus == CLAuthorizationStatus.notDetermined {
			requestAuthorization()
		} else {
			try? startTracking()
		}
	}
}
