//
//  UserAddress.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/1/12.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import CoreLocation
import Foundation
import Observation
import SwiftData

@Observable
final class UserAddress {
  var id: String

  var latitude: Double?
  var longitude: Double?
  var postalAddress: String?

  init(
    latitude: Double? = nil,
    longitude: Double? = nil,
    postalAddress: String? = nil
  ) {
    self.id = UUID().uuidString
    self.latitude = latitude
    self.longitude = longitude
    self.postalAddress = postalAddress
  }

  var location: CLLocationCoordinate2D? {
    if let latitude,
       let longitude {
      return .init(latitude: latitude, longitude: longitude)
    }
    return nil
  }
}

extension UserAddress {
  convenience init?(sdAddress: SDUserAddress?) {
    guard let sdAddress else { return nil }
    self.init(
      latitude: sdAddress.latitude,
      longitude: sdAddress.longitude,
      postalAddress: sdAddress.postalAddress
    )
  }
}

extension UserAddress {
  convenience init?(cllocation: CLLocation?) {
    guard let cllocation else { return nil }
    self.init(
      latitude: cllocation.coordinate.latitude,
      longitude: cllocation.coordinate.longitude,
      postalAddress: ""
    )
  }
}
