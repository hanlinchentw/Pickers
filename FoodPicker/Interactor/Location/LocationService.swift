//
//  LocaionHandler.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/7.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import Combine
import CoreLocation
import MapKit

enum LoactionError: Error {
  case locationNotFound(message: String)
}

class LocationService {
	
	@Inject var locationManager: LocationManager
	
  @Published var lastLocation: CLLocation?

	func getLatitude() throws -> Double {
		guard let latitude = lastLocation?.coordinate.latitude else {
			throw LoactionError.locationNotFound(message: "\(#function) not found")
		}
		return latitude
	}

	func getLongitude() throws -> Double {
		guard let longitude = lastLocation?.coordinate.longitude else {
			throw LoactionError.locationNotFound(message: "\(#function) not found")
		}
		return longitude
	}

  var latitude: Double? {
		return lastLocation?.coordinate.latitude
  }

  var longitude: Double? {
    return lastLocation?.coordinate.longitude
  }

  func distanceFromCurrent(_ targetLatitude: Double, _ targetLongitude: Double) -> Int? {
		guard let latitude = latitude, let longitude = longitude,
					!latitude.isNaN, !longitude.isNaN,
					!targetLatitude.isNaN, !targetLongitude.isNaN else { return nil }
    let currentLocation = CLLocation(latitude: latitude, longitude: longitude)
    let targetLocation = CLLocation(latitude: targetLatitude, longitude: targetLongitude)
    let distance = targetLocation.distance(from: currentLocation)
    return Int(distance)
  }
}
