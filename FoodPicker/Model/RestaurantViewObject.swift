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
	var name: String
	var price: String?
	var rating: Double?
	var reviewCount: Int?
	var businessCategory: String?
  var imageUrls: [URL?] = []
  var latitude: Double
  var longitude: Double

  var isLiked: Bool = false
  var isSelected: Bool = false
  var isClosed: Bool = false
}

extension RestaurantViewObject: Equatable {}

extension RestaurantViewObject: Hashable {}

extension RestaurantViewObject {
	static let dummy = RestaurantViewObject(
		id: UUID().uuidString,
		name: "Test Picker",
		imageUrls: [
			URL(string: "https://www.pizzarock.com.tw/uploads/6/3/7/3/6373268/website-main-page-pizza-rock-001_orig.jpg")
		],
		latitude: 23.5,
		longitude: 121.0
	)
}
