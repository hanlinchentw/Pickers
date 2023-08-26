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
	func didTapAddButton(object: RestaurantViewObject)
}

final class ExploreViewModelImpl: ExploreViewModel, ObservableObject {
	var selectionStore: RestaurantSelectionStore
	let locationManager: LocationManagerProtocol
	let nearbySearchProvider: NearbySearchProvider
	@Published private(set)var viewObjects: [RestaurantViewObject] = []
	var viewObjectsPublisher: Published<[RestaurantViewObject]>.Publisher { $viewObjects }

	init(
		nearbySearchProvider: NearbySearchProvider = NearbySearchProviderImpl(),
		locationManager: LocationManagerProtocol = LocationManager.shared,
		selectionStore: RestaurantSelectionStore
	) {
		self.nearbySearchProvider = nearbySearchProvider
		self.locationManager = locationManager
		self.selectionStore = selectionStore
	}

	var lastLocation: CLLocationCoordinate2D? {
		locationManager.lastLocation
	}

	func viewObject(for index: Int) -> RestaurantViewObject {
		var object = viewObjects[index]
		object.isSelected = selectionStore.selectedRestaurants.contains(where: { object.id == $0.id })
		return object
	}

	func fetch() {
		Task {
			do {
				guard let lat = lastLocation?.latitude, let lon = lastLocation?.longitude else {
					return
				}
				let results = PlaceApiResult.staticData
//				let results = try await nearbySearchProvider.search(keyword: "food", latitude: lat , longitude: lon)
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
	
	func didTapAddButton(object: RestaurantViewObject) {
		let firstIndex = selectionStore.selectedRestaurants.firstIndex(where: { $0.id == object.id })
		if let firstIndex {
			selectionStore.selectedRestaurants.remove(at: firstIndex)
		} else {
			selectionStore.selectedRestaurants.append(RestaurantSelectionDomainModel(id: object.id, name: object.name))
		}
	}
}
