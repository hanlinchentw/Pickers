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
	init(name: String) {
		self.name = name
		self.id = UUID().uuidString
	}
}
extension RestaurantViewObject: Equatable {}

extension RestaurantViewObject: Hashable {}
