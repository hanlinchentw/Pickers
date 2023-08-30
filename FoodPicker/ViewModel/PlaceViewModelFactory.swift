//
//  PlaceViewModelFactory.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/30.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation

final class PlaceViewModelFactory {
	static func placeViewModel(from apiResults: ([PlaceApiResult]), andImageUrls placeImageUrls: [[URL]]) -> [PlaceViewModel] {
		zip(apiResults, placeImageUrls).map { (place, images) in
			PlaceViewModel(
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
