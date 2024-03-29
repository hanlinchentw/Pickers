//
//  RestaurantViewObject.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/3.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

struct RestaurantViewObject: Identifiable {
  var id: String
	var businessCategory: String?
  var imageUrl: String?
  var latitude: Double?
  var longitude: Double?
  var name: String
  var price: String?
  var rating: Double?
  var reviewCount: Int?

  var isLiked: Bool = false
  var isSelected: Bool = false
  var isClosed: Bool = false
}

extension RestaurantViewObject {
  init(restaurant: Restaurant) {
    self.businessCategory = restaurant.businessCategory
    self.id = restaurant.id
    self.imageUrl = restaurant.imageUrl
    self.latitude = restaurant.latitude
    self.longitude = restaurant.longitude
    self.name = restaurant.name
    self.price = restaurant.price
    self.rating = restaurant.rating
		self.reviewCount = Int(restaurant.reviewCount)
    self.isLiked = restaurant.isLiked
    self.isSelected = restaurant.isSelected
    self.isClosed = restaurant.isClosed
  }
}

extension RestaurantViewObject {
  init(business: Business) {
    self.id = business.id
    self.name = business.name
    self.imageUrl = business.imageUrl
    self.reviewCount = business.reviewCount
    self.rating = business.rating
    self.price = business.price ?? "-"
    self.businessCategory = business.categories[safe: 0]?.title ?? "Cusine"
    self.latitude = business.coordinates.latitude
    self.longitude = business.coordinates.longitude
  }
}

extension RestaurantViewObject {
	init(name: String) {
		self.name = name
		self.id = UUID().uuidString
	}
}
extension RestaurantViewObject: Equatable {}

extension RestaurantViewObject: Hashable {}
