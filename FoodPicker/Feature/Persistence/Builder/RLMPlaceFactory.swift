//
//  RLMPlaceFactory.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/31.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation
import RealmSwift

final class RLMPlaceFactory {
	func rlmPlaces(with model: PlacePocketViewModel) -> [RLM_Place] {
		model.items.map {
			(
				RLM_Place(
				id: $0.id,
				name: $0.name,
				price: $0.price,
				rating: $0.rating,
				reviewCount: $0.reviewCount,
				businessCategory: $0.businessCategory,
				latitude: $0.latitude,
				longitude: $0.longitude
				),
				$0.imageUrls
			)
		}.map { (rlmPlace, imageUrls) in
			rlmPlace.imageUrls.append(objectsIn: imageUrls.compactMap { $0?.absoluteString })
			return rlmPlace
		}
	}
}
