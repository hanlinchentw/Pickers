//
//  PlaceRepository.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/27.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation

protocol PlaceRepositoryProtocol {
	func fetch(completion: @escaping ([PlaceApiResult], [[URL]]) -> Void)
}

final class PlaceRepository: PlaceRepositoryProtocol {
	func fetch(completion: @escaping ([PlaceApiResult], [[URL]]) -> Void) {
		Task {
			do {
//				guard let lat = lastLocation?.latitude, let lon = lastLocation?.longitude else {
//					return
//				}
				let results = PlaceApiResult.staticData
//				let results = try await nearbySearchProvider.search(keyword: "food", latitude: lat , longitude: lon)
				let photoReferences = results.map { ($0.photos ?? []).map(\.photoReference) }
				let photoUrls = photoReferences.compactMap { $0.compactMap { PhotoRequest(reference: $0).url } }
				await MainActor.run {
					completion(results, photoUrls)
				}
			} catch {
				print(">>> fetch error=\(error.localizedDescription)")
			}
		}
	}
}
