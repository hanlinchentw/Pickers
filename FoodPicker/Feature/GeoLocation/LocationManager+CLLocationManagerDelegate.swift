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
	private func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) async {
		guard let location = locations.last else { return }
		lastLocation = location.coordinate
	}
	
	private func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) async {
		if authorizationStatus == CLAuthorizationStatus.restricted,
			 authorizationStatus == CLAuthorizationStatus.denied {
			self.status = .stopped
		} else if authorizationStatus == CLAuthorizationStatus.notDetermined {
			requestAuthorization()
		}
	}
}
