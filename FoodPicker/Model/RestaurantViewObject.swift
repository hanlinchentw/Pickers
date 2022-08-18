//
//  RestaurantCardViewObject.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/8.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData
import SwiftUI

enum RestaurantSorting: Int, CaseIterable {
  case all
  case popular

  var description: String {
    switch self {
    case .all : return "Restaurant Nearby"
    case .popular: return "Popular"
    }
  }
  var sortBy: String {
    switch self {
    case .all: return "distance"
    case .popular: return "rating"
    }
  }
}
struct MainListSectionViewObject {
  var section: RestaurantSorting
  var content: Array<RestaurantViewObject>
}

class RestaurantViewObject: Identifiable {
  let id: String
  let name: String
  let rating: Double
  var isClosed: Bool?
  let imageUrl: URL?
  let reviewCount: Int
  let price: String
  let coordinates: CLLocationCoordinate2D
  let businessCategory: String


  var isSelected: Bool = false
  var isLiked: Bool = false
  init(business: Business) {
    self.id = business.id
    self.name = business.name
    self.imageUrl = URL(string: business.imageUrl ?? defaultImageURL)
    self.rating = business.rating
    self.isClosed = business.isClosed
    self.reviewCount = business.reviewCount
    self.price = business.price ?? "$"
    self.coordinates = business.coordinates
    self.businessCategory = business.categories[safe: 0]?.title ?? "Cuisine"
  }
}

// MARK: - Core data init
extension RestaurantViewObject {
  convenience init(restaurant: Restaurant) {
    let business = Business(id: restaurant.id,
                            name: restaurant.name,
                            rating: restaurant.rating,
                            price: restaurant.price,
                            imageUrl: "\(restaurant.imageUrl)",
                            distance: nil,
                            isClosed: nil,
                            categories: [Categories.init(title: restaurant.businessCategory)],
                            reviewCount: Int(restaurant.reviewCount),
                            coordinates: CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude))
    self.init(business: business)
//    self.id = restaurant.id
//    self.name = restaurant.name
//    self.imageUrl = restaurant.imageUrl ?? URL(string: defaultImageURL)!
//    self.rating = restaurant.rating
//    self.reviewCount = Int(restaurant.reviewCount)
//    self.price = restaurant.price
//    self.coordinates = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
//    self.businessCategory = restaurant.businessCategory
  }
}
