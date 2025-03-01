//
//  PlaceRepository.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/27.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import CoreLocation
import Foundation

struct SearchCategory: RawRepresentable {
  var rawValue: String

  static let bakery = SearchCategory(rawValue: "bakery")
  static let brewery = SearchCategory(rawValue: "brewery")
  static let cafe = SearchCategory(rawValue: "cafe")
  static let foodMarket = SearchCategory(rawValue: "foodMarket")
  static let restaurant = SearchCategory(rawValue: "restaurant")
  static let nightlife = SearchCategory(rawValue: "nightlife")
  static let store = SearchCategory(rawValue: "store")

  static var all: [SearchCategory] {
    [.bakery, .brewery, .cafe, .foodMarket, .restaurant, .nightlife, .store]
  }
}

struct PlaceSearchConfig {
  let location: CLLocationCoordinate2D
  let keyword: String?
  let categories: [SearchCategory]
  let radius: CGFloat
}

protocol PlaceRepository {
  var isLoading: Bool { get }
  var hasMoreToLoad: Bool { get }
  func fetch(config: PlaceSearchConfig) async throws -> [Business]
  func fetchMore(config: PlaceSearchConfig) async throws -> [Business]
}
