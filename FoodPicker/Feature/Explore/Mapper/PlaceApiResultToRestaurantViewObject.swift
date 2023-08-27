//
//  MapPlaceApiResultToRestaurantViewObject.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/26.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation

extension Zip2Sequence where Sequence1 == [PlaceApiResult], Sequence2 == [[URL?]] {
	func mapPlaceApiResultToRestaurantViewObject() -> [PlaceListViewModel] {
		self.map { (place, images) in
			PlaceListViewModel(
				id: place.placeId,
				name: place.name,
				rating: place.rating,
				imageUrls: images,
				latitude: place.geometry.location.lat,
				longitude: place.geometry.location.lng,
				isClosed: false,
				isSelected: false
			)
		}
	}
}
