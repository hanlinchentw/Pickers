//
//  PlaceViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/27.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import CoreLocation
import Foundation
import SwiftData

final class PlaceViewModel {
  var id: String
  var name: String
  var price: String?
  var rating: Double?
  var reviewCount: Int?
  var category: String?
	var imageUrl: URL?
  var latitude: Double
  var longitude: Double
	var postalAddress: String?

	var isClosed = false

  var isSelected = false
  var isLiked = false

	init(business: Business) {
		self.id = business.id
		self.name = business.name
		self.price = business.price
		self.rating = business.rating
		self.reviewCount = business.reviewCount
		self.category = business.categories[safe: 0]?.title
		self.imageUrl =
			if let imageUrl = business.imageUrl {
				URL(string: imageUrl)
			} else {
				nil
			}
		self.latitude = business.coordinates.latitude
		self.longitude = business.coordinates.longitude
		self.isClosed = business.isClosed ?? false
	}

	func distance(to location: CLLocationCoordinate2D) -> Distance {
		return Distance.meter(
			CLLocation(
				latitude: latitude,
				longitude: longitude
			)
			.distance(
				from: CLLocation(
					latitude: location.latitude,
					longitude: location.longitude
				)
			)
		)
	}
}

extension PlaceViewModel: Equatable {
  static func == (lhs: PlaceViewModel, rhs: PlaceViewModel) -> Bool {
    lhs.id == rhs.id
  }
}

//extension PlaceViewModel {
//  static var dummy: PlaceViewModel {
//    PlaceViewModel(
//      id: "123",
//      name: "McDonald's",
//      price: "$$$",
//      rating: 5.0,
//      reviewCount: 125,
//      category: "food",
//      imageUrl: Constants.defaultImageURL,
//      latitude: 23.5,
//      longitude: 123.1,
//      isClosed: false,
//      distance: Distance.meter(123),
//      isSelected: false,
//      isLiked: false
//    )
//  }
//}
