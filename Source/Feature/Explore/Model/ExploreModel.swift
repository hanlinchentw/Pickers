//
//  ExploreModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/1/6.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import CoreLocation
import Foundation
import Observation
import SwiftData
import SwiftUI

@Observable
class ExploreModel {
  let placeRepository: PlaceRepository

  private(set) var viewModels = [PlaceViewModel]()

  var searchRange = Distance.kilometer(5)

	init(placeRepository: PlaceRepository = DependencyContainer.shared.getService()) {
		self.placeRepository = placeRepository
	}

  var searchRangeBinding: Binding<Double> {
    Binding {
      self.searchRange.value
    } set: { newValue in
      if newValue.truncatingRemainder(dividingBy: 1000) > 0 {
        self.searchRange = Distance.kilometer(newValue / 1000)
      } else {
        self.searchRange = Distance.meter(newValue)
      }
    }
  }

  var hasMoreToLoad: Bool {
    placeRepository.hasMoreToLoad
  }

  func fetch(location: CLLocationCoordinate2D) async {
    guard !placeRepository.isLoading else { return }
    do {
      let result = try await placeRepository.fetch(
        config: PlaceSearchConfig(
          location: location,
          keyword: "",
          categories: SearchCategory.all,
          radius: searchRange.value
        )
      )
			print(">>> DEBUG: Explore fetch \(result.map { $0.name })")
			Task { @MainActor in
				viewModels = result.map {
					PlaceViewModel(business: $0)
				}
			}
    } catch {
      print(error.localizedDescription)
    }
  }

  func fetchMore(location: CLLocationCoordinate2D) async {
    guard !placeRepository.isLoading else { return }
    do {
			let result = try await placeRepository.fetchMore(
        config: PlaceSearchConfig(
          location: location,
          keyword: "food",
          categories: [],
          radius: 5000
        )
      )
			print(">>> DEBUG: Explore fetchMore \(result.map { $0.name })")
			Task { @MainActor in
				viewModels += result.map {
					PlaceViewModel(business: $0)
				}
			}
    } catch {
      print(error.localizedDescription)
    }
  }

  func onClickLikeButton(_ viewModel: PlaceViewModel) {
    let container: PlaceModelContainer = DependencyContainer.shared.getService()
    let context = ModelContext(container.modelContainer)
    let item = mapViewModelIntoPlaceModel(viewModel: viewModel)
    let id = viewModel.id
    let predicate = #Predicate<SDPlaceModel> { $0.id == id && $0.isLiked }
    let rowCount = try? context.fetchCount(FetchDescriptor(predicate: predicate))
    if let rowCount, rowCount > 0 {
      context.delete(item)
    } else {
      context.insert(item)
    }
    try? context.save()
    if let firstIndex = viewModels.firstIndex(of: viewModel) {
      viewModels[firstIndex].isLiked.toggle()
    }
  }

  func isLiked(_ business: Business) -> Bool {
    let container: PlaceModelContainer = DependencyContainer.shared.getService()
    let context = ModelContext(container.modelContainer)
		let id = business.id
    let predicate = #Predicate<SDPlaceModel> {
      $0.id == id && $0.isLiked
    }
    let fetchDescript = FetchDescriptor(predicate: predicate)
    let rowCount = try? context.fetchCount(fetchDescript)
    return rowCount != 0
  }

  func distance(
    from business: Business,
    to location: CLLocationCoordinate2D
  ) -> Distance {
    if let distance = business.distance { return Distance.meter(distance) }
    return Distance.meter(
      CLLocation(
        latitude: business.coordinates.latitude,
        longitude: business.coordinates.longitude
      )
      .distance(
        from: CLLocation(
          latitude: location.latitude,
          longitude: location.longitude
        )
      )
    )
  }

  func mapViewModelIntoPlaceModel(viewModel: PlaceViewModel) -> SDPlaceModel {
    .init(
      id: viewModel.id,
      name: viewModel.name,
      rating: viewModel.rating,
      price: viewModel.price,
			imageUrl: viewModel.imageUrl?.absoluteString,
      category: viewModel.category,
      reviewCount: viewModel.reviewCount ?? 0,
      latitude: viewModel.latitude,
      longitude: viewModel.longitude,
      isLiked: viewModel.isLiked
    )
  }
}
