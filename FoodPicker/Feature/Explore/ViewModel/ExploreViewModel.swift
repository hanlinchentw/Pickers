//
//  ExplorerViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/29.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation
import CoreLocation
import Combine
import UIKit

protocol ExploreViewModel {
	var nearbySearchProvider: NearbySearchProvider { get }
	var viewObjects: [RestaurantViewObject] { get }
	var viewObjectsPublisher: Published<[RestaurantViewObject]>.Publisher { get }
	func viewObject(for index: Int) -> RestaurantViewObject
	func fetch()
}

final class ExploreViewModelImpl: ExploreViewModel, ObservableObject {
	
	let locationManager: LocationManagerProtocol
	let nearbySearchProvider: NearbySearchProvider
	@Published private(set)var viewObjects: [RestaurantViewObject] = []
	var viewObjectsPublisher: Published<[RestaurantViewObject]>.Publisher { $viewObjects }

	init(
		nearbySearchProvider: NearbySearchProvider = NearbySearchProviderImpl(),
		locationManager: LocationManagerProtocol = LocationManager.shared
	) {
		self.nearbySearchProvider = nearbySearchProvider
		self.locationManager = locationManager
	}
	
	var lastLocation: CLLocationCoordinate2D? {
		locationManager.lastLocation
	}
	
	func viewObject(for index: Int) -> RestaurantViewObject {
		viewObjects[index]
	}
	
	func fetch() {
		Task {
			do {
				guard let lat = lastLocation?.latitude,
							let lon = lastLocation?.longitude else {
					fatalError("need to throw error here")
				}
				let results = try await nearbySearchProvider.search(keyword: "food", latitude: lat , longitude: lon)
				let photoReferences = results.map { ($0.photos ?? []).map(\.photoReference) }
				let photoUrls = photoReferences.map { $0.map { PhotoRequest(reference: $0).url } }
				await MainActor.run {
					viewObjects = zip(results, photoUrls).mapPlaceApiResultToRestaurantViewObject()
				}
				print(">>> fetch result=\(results)")
				
			} catch {
				print(">>> fetch error=\(error.localizedDescription)")
			}
		}
	}
}
extension Zip2Sequence where Sequence1 == [PlaceApiResult], Sequence2 == [[URL?]] {
	func mapPlaceApiResultToRestaurantViewObject() -> [RestaurantViewObject] {
		self.map { (place, images) in
			RestaurantViewObject(
				id: place.placeId,
				name: place.name,
				rating: place.rating,
				imageUrls: images,
				latitude: place.geometry.location.lat,
				longitude: place.geometry.location.lng
			)
		}
	}
}
