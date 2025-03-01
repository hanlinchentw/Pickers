//
//  LocationManager+CLLocationManagerDelegate.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/10.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Contacts
import CoreLocation
import Foundation
import SwiftData

extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    print("\(#function) location=\(location)")
    currLocation = location
    Task.detached {
      let userAddress = SDUserAddress(
        latitude: location.coordinate.latitude,
        longitude: location.coordinate.longitude
      )
      if let address = await self.lookUpCurrentLocation(location) {
        userAddress.postalAddress = address
      }
      let container: PlaceModelContainer = DependencyContainer.shared.getService()
      let userAddressCount = try? container.fetchCount(SDUserAddress.self, descriptor: .init())
      if userAddressCount == 0 {
        try container.insert(userAddress)
      } else {
      }
    }
  }

  func lookUpCurrentLocation(_ location: CLLocation) async -> String? {
    let geocoder = CLGeocoder()
    let placemarks = try? await geocoder.reverseGeocodeLocation(location)
    guard let firstLocation = placemarks?[0],
          let postalAddress = firstLocation.postalAddress else {
      return nil
    }
    let address = CNMutablePostalAddress()
    address.street = postalAddress.street
    return CNPostalAddressFormatter().string(from: address)
  }
}
