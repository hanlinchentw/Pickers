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

class LocationService: NSObject, ObservableObject {
  static let shared = LocationService()
  static let locationManager = CLLocationManager()

  @Published var lastLocation: CLLocation?

  override init() {
    super.init()
    LocationService.locationManager.delegate = self
    LocationService.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    LocationService.locationManager.requestWhenInUseAuthorization()
    LocationService.locationManager.pausesLocationUpdatesAutomatically = true
    LocationService.locationManager.startMonitoringSignificantLocationChanges()
  }

  var latitude: Double? {
    return lastLocation?.coordinate.latitude
  }

  var longitude: Double? {
    return lastLocation?.coordinate.longitude
  }

  func getDistanceFromCurrentLocation(_ targetLatitude: Double, _ targetLongitude: Double) -> Int {
    guard let latitude = latitude, let longitude = longitude else { return 1000 }
    let currentLocation = CLLocation(latitude: latitude, longitude: longitude)
    let targetLocation = CLLocation(latitude: targetLatitude, longitude: targetLongitude)
    let distance = targetLocation.distance(from: currentLocation)
    return Int(distance)
  }
}

//MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    if manager.authorizationStatus == .denied {
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    lastLocation = location
    print(#function, location)

  }
}
