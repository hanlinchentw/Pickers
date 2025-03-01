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
import MapKit

enum LocationEnabled {
  case idle
  case enabled
  case disabled
}

@Observable
class LocationManager: NSObject {
  var isLocationEnabled: LocationEnabled = .idle

  var currLocation: CLLocation? {
    didSet {
      print("currLocation >> \(currLocation)")
    }
  }

  private let locationManager = CLLocationManager()

  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }

  func requestAuthorization() {
    locationManager.requestWhenInUseAuthorization()
  }

  func updateStatus() {
    switch locationManager.authorizationStatus {
    case .notDetermined:
      isLocationEnabled = .idle
      requestAuthorization()
    case .authorizedAlways, .authorizedWhenInUse:
      isLocationEnabled = .enabled
      locationManager.startUpdatingLocation()
      locationManager.startUpdatingHeading()
      currLocation = locationManager.location
    case .restricted, .denied:
      isLocationEnabled = .disabled
    @unknown default:
      stopTracking()
    }
  }

  func stopTracking() {
    guard isLocationEnabled == LocationEnabled.enabled else {
      return
    }
    locationManager.stopUpdatingLocation()
    locationManager.stopUpdatingHeading()
    isLocationEnabled = .disabled
  }
}
