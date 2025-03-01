//
//  SDPlaceModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/3/3.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import Foundation
import SwiftData

@Model
class SDPlaceModel {
  @Attribute(.unique) let id: String
  let name: String
  let rating: Double?
  let price: String?
  let imageUrl: String?
  let category: String?
  let reviewCount: Int
  var latitude: Double
  var longitude: Double
  var isLiked: Bool

  init(
    id: String,
    name: String,
    rating: Double?,
    price: String?,
    imageUrl: String?,
    category: String?,
    reviewCount: Int,
    latitude: Double,
    longitude: Double,
    isLiked: Bool
  ) {
    self.id = id
    self.name = name
    self.rating = rating
    self.price = price
    self.imageUrl = imageUrl
    self.category = category
    self.reviewCount = reviewCount
    self.latitude = latitude
    self.longitude = longitude
    self.isLiked = isLiked
  }
}

extension SDPlaceModel {
  static var dummy: SDPlaceModel {
    SDPlaceModel(
      id: UUID().uuidString,
      name: "McDonalds'",
      rating: 5.0,
      price: "$$",
      imageUrl: "https://mcdonalds.com",
      category: "fast food",
      reviewCount: 123,
      latitude: 0,
      longitude: 0,
      isLiked: false
    )
  }
}
