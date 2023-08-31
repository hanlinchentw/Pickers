//
//  RLM_Place.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/30.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation
import RealmSwift

class RLM_Place: Object {
	@Persisted(primaryKey: true) var id: String
	@Persisted var name: String
	@Persisted var price: String?
	@Persisted var rating: Double?
	@Persisted var reviewCount: Int?
	@Persisted var businessCategory: String?
	@Persisted var imageUrls: List<String>
	@Persisted var latitude: Double
	@Persisted var longitude: Double

	init(id: String, name: String, price: String? = nil, rating: Double? = nil, reviewCount: Int? = nil, businessCategory: String? = nil, latitude: Double, longitude: Double) {
		super.init()
		self.id = id
		self.name = name
		self.price = price
		self.rating = rating
		self.reviewCount = reviewCount
		self.businessCategory = businessCategory
		self.latitude = latitude
		self.longitude = longitude
	}
}
