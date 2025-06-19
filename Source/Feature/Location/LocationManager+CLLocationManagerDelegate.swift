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

    Task {
			try? await insertUserAddressIfNeeded(location)
    }
  }

	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
			manager.startUpdatingLocation()
			manager.startUpdatingHeading()
			Task {
				if let location = manager.location {
					try? await insertUserAddressIfNeeded(location)
				}
			}
		}
	}

	func insertUserAddressIfNeeded(_ location: CLLocation) async throws {
		let userAddress = await createUserAddress(location)
		let container: PlaceModelContainer = DependencyContainer.shared.getService()
		let userAddressCount = try container.fetchCount(UserAddress.self, descriptor: .init())
		if userAddressCount == 0 {
			setCurrentAddress(userAddress.id)
			try insertUserAddress(userAddress)
		}
	}

	func createUserAddress(_ location: CLLocation) async -> UserAddress {
		let userAddress = UserAddress(
			latitude: location.coordinate.latitude,
			longitude: location.coordinate.longitude
		)
		if let address = await lookUpCurrentLocation(location) {
			userAddress.postalAddress = address
		}
		return userAddress
	}

  private func lookUpCurrentLocation(_ location: CLLocation) async -> String? {
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

extension CLLocation {
		func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
				CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
		}
}
