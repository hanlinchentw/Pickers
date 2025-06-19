//
//  LocationManager.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/9.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Combine
import Contacts
import CoreLocation
import Defaults
import MapKit

enum LocationEnabled {
  case idle
  case enabled
  case disabled
}

@Observable
final class LocationManager: NSObject {
  private let locationManager = CLLocationManager()
	private var containerWrapper: PlaceModelContainer { DependencyContainer.shared.getService() }

  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }

  func requestAuthorization() {
    locationManager.requestWhenInUseAuthorization()
  }

	func getLocationAuthStatus() -> LocationEnabled {
		switch locationManager.authorizationStatus {
		case .notDetermined:
			return .idle
		case .authorizedAlways, .authorizedWhenInUse:
			return .enabled
		case .restricted, .denied:
			return .disabled
		@unknown default:
			return .idle
		}
	}

  func askPermissionIfNeeded() {
    switch locationManager.authorizationStatus {
    case .notDetermined:
      requestAuthorization()
    case .authorizedAlways, .authorizedWhenInUse:
      locationManager.startUpdatingLocation()
      locationManager.startUpdatingHeading()
			Task {
				if let location = locationManager.location {
					try? await insertUserAddressIfNeeded(location)
				}
			}
    default:
      stopTracking()
    }
  }

  func stopTracking() {
    locationManager.stopUpdatingLocation()
    locationManager.stopUpdatingHeading()
  }

	func insertUserAddress(_ address: UserAddress) throws {
		try containerWrapper.insert(address)
	}

	func setCurrentAddress(_ id: String) {
		Defaults[.currentAddressId] = id
	}

	func currentAddressId() -> String? {
		Defaults[.currentAddressId]
	}
}
