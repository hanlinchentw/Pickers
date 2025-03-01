//
//  Business.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/11/17.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import CoreLocation
import Foundation
import MapKit

struct Root: Decodable {
  let businesses: [Business]
}

struct Business: Codable {
  let id: String
  let name: String
  let rating: Double?
  let price: String?
  let imageUrl: String?
  let distance: Double?
  let isClosed: Bool?
  let categories: [String]
  let reviewCount: Int?
  let coordinates: CLLocationCoordinate2D
}

extension CLLocationCoordinate2D: Codable {
  enum CodingKeys: CodingKey {
    case latitude
    case longitude
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let lat = try container.decode(Double.self, forKey: .latitude)
    let lon = try container.decode(Double.self, forKey: .longitude)
    self.init(latitude: lat, longitude: lon)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(latitude, forKey: .latitude)
    try container.encode(longitude, forKey: .longitude)
  }
}

extension Business: Equatable {
  static func == (lhs: Business, rhs: Business) -> Bool {
    lhs.id == rhs.id
  }
}

extension Business {
  init(from mapItem: MKMapItem) {
    self.id = mapItem.placemark.coordinate.latitude.description + mapItem.placemark.coordinate.longitude.description
    self.name = mapItem.name ?? "Unknown"
    self.rating = nil // Default as MKMapItem doesn't provide rating
    self.price = nil // MKMapItem doesn't have price info
    self.imageUrl = nil // No image URL in MKMapItem
    self.distance = mapItem.distanceFromUser // Custom computed property
    self.isClosed = nil // MKMapItem doesn't indicate if business is closed
    self.categories = mapItem.pointOfInterestCategoryTitles
    self.reviewCount = nil // Default as MKMapItem doesn't provide review count
    self.coordinates = mapItem.placemark.coordinate
  }
}

// Helper extension to get categories as strings from MKMapItem
extension MKMapItem {
  var pointOfInterestCategoryTitles: [String] {
    guard
      let poiCategory = pointOfInterestCategory,
      let category = mapPoiCategory(poiCategory)
    else {
      return []
    }
    return [category]
  }

  func mapPoiCategory(_ poi: MKPointOfInterestCategory) -> String? {
    switch poi {
    case .restaurant: "Restaurant"
    case .bakery: "Bakery"
    case .brewery: "Brewery"
    case .cafe: "Cafe"
    case .foodMarket: "Food market"
    case .nightlife: "Night life"
    case .store: "Store"
    default:
      nil
    }
  }

  // Example method to calculate the distance from user's location
  var distanceFromUser: Double? {
    guard let userLocation = CLLocationManager().location else { return nil }
    let mapItemLocation = CLLocation(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
    return userLocation.distance(from: mapItemLocation)
  }
}
