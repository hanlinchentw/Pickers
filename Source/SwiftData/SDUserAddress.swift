//
//  SDUserAddress.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/3/3.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import CoreLocation
import Foundation
import SwiftData

@Model
class SDUserAddress {
  @Attribute(.unique) var id: String

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

  @Transient var location: CLLocationCoordinate2D? {
    if let latitude,
       let longitude {
      return .init(latitude: latitude, longitude: longitude)
    }
    return nil
  }
}
