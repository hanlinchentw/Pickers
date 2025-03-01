//
//  PlaceViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/27.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import CoreLocation
import Foundation

@Observable
class PlaceViewModel {
  var id: String
  var name: String
  var price: String?
  var rating: Double?
  var reviewCount: Int?
  var category: String?
  var imageUrl: String?
  var latitude: Double
  var longitude: Double
  var isClosed: Bool?

  var distance: Distance?
  var isSelected: Bool
  var isLiked: Bool

  init(
    id: String,
    name: String,
    price: String? = nil,
    rating: Double? = nil,
    reviewCount: Int? = nil,
    category: String? = nil,
    imageUrl: String? = nil,
    latitude: Double,
    longitude: Double,
    isClosed: Bool? = nil,
    distance: Distance? = nil,
    isSelected: Bool,
    isLiked: Bool
  ) {
    self.id = id
    self.name = name
    self.price = price
    self.rating = rating
    self.reviewCount = reviewCount
    self.category = category
    self.imageUrl = imageUrl
    self.latitude = latitude
    self.longitude = longitude
    self.isClosed = isClosed
    self.distance = distance
    self.isSelected = isSelected
    self.isLiked = isLiked
  }
}

extension PlaceViewModel: Equatable {
  static func == (lhs: PlaceViewModel, rhs: PlaceViewModel) -> Bool {
    lhs.id == rhs.id
  }
}

extension PlaceViewModel {
  static var dummy: PlaceViewModel {
    PlaceViewModel(
      id: "123",
      name: "McDonald's",
      price: "$$$",
      rating: 5.0,
      reviewCount: 125,
      category: "food",
      imageUrl: Constants.defaultImageURL,
      latitude: 23.5,
      longitude: 123.1,
      isClosed: false,
      distance: Distance.meter(123),
      isSelected: false,
      isLiked: false
    )
  }
}
