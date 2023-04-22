//
//  NearbySearchProvider.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/22.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation
import APIKit

final class NearbySearchProvider {
	var keyword: String
	var latitude: Double
	var longitude: Double
	
	init(keyword: String, latitude: Double, longitude: Double) {
		self.keyword = keyword
		self.latitude = latitude
		self.longitude = longitude
	}
	
	func search() async throws -> Array<PlaceApiResult> {
		let request = NearbySearchRequest(keyword: keyword, latitude: latitude, longitude: longitude)
		let response = try await Session.response(for: request)
		return response.results
	}
}
