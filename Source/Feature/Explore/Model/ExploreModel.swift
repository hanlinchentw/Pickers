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
  var placeRepositories: [PlaceRepository] = []
  var selectStore: PlacesSelectionStore?

  private(set) var viewModels = [PlaceViewModel]()

  var searchRange = Distance.kilometer(5)

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

  func setupRepos(placeRepositories: [PlaceRepository], selectStore: PlacesSelectionStore?) {
    self.placeRepositories = placeRepositories
    self.selectStore = selectStore
  }

  func reachEnd(index: Int) -> Bool {
    viewModels.endIndex == index + 1
  }

  var hasMoreToLoad: Bool {
    placeRepositories.contains(where: \.hasMoreToLoad)
  }

  func fetch(location: CLLocationCoordinate2D?) async {
    guard let location,
          !placeRepositories.isEmpty, !placeRepositories.contains(where: \.isLoading) else { return }
    var viewModels = [PlaceViewModel]()
    for placeRepository in placeRepositories {
      do {
        let result = try await placeRepository.fetch(
          config: PlaceSearchConfig(
            location: location,
            keyword: "",
            categories: SearchCategory.all,
            radius: searchRange.value
          )
        )
        viewModels += result.map {
          PlaceViewModel(
            id: $0.id,
            name: $0.name,
            price: $0.price,
            rating: $0.rating,
            reviewCount: $0.reviewCount,
            category: $0.categories[safe: 0],
            imageUrl: $0.imageUrl,
            latitude: $0.coordinates.latitude,
            longitude: $0.coordinates.longitude,
            isClosed: $0.isClosed ?? false,
            distance: distance(from: $0, to: location),
            isSelected: isSelected($0),
            isLiked: isLiked($0)
          )
        }
      } catch {
        print(error.localizedDescription)
      }
    }
    self.viewModels = viewModels.sorted(by: { $0.distance ?? .meter(0) < $1.distance ?? .meter(0) })
  }

  func fetchMore(location: CLLocationCoordinate2D?) async {
    guard let location,
          !placeRepositories.isEmpty, !placeRepositories.contains(where: \.isLoading) else { return }
    var viewModels = [PlaceViewModel]()
    for placeRepository in placeRepositories {
      do {
        let result = try await placeRepository.fetch(
          config: PlaceSearchConfig(
            location: location,
            keyword: "food",
            categories: [],
            radius: 5000
          )
        )
        viewModels += result.map { place in
          PlaceViewModel(
            id: place.id,
            name: place.name,
            price: place.price,
            rating: place.rating,
            reviewCount: place.reviewCount,
            category: place.categories[safe: 0],
            imageUrl: place.imageUrl,
            latitude: place.coordinates.latitude,
            longitude: place.coordinates.longitude,
            isClosed: place.isClosed ?? false,
            distance: distance(from: place, to: location),
            isSelected: isSelected(place),
            isLiked: isLiked(place)
          )
        }
      } catch {
        print(error.localizedDescription)
      }
    }
    self.viewModels += viewModels.sorted(by: { $0.distance ?? .meter(0) < $1.distance ?? .meter(0) })
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

  func onClickSelectButton(viewModel: PlaceViewModel) {
    selectStore?.onClickSelectButton(viewModel: viewModel)

    if let firstIndex = viewModels.firstIndex(of: viewModel) {
      viewModels[firstIndex].isSelected.toggle()
    }
  }

  func isLiked(_ business: Business) -> Bool {
    let container: PlaceModelContainer = DependencyContainer.shared.getService()
    let context = ModelContext(container.modelContainer)
    let predicate = #Predicate<SDPlaceModel> {
      $0.id == business.id && $0.isLiked
    }
    let fetchDescript = FetchDescriptor(predicate: predicate)
    let rowCount = try? context.fetchCount(fetchDescript)
    return rowCount != 0
  }

  func isSelected(_ business: Business) -> Bool {
    selectStore?.isSelected(id: business.id) ?? false
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
      imageUrl: viewModel.imageUrl,
      category: viewModel.category,
      reviewCount: viewModel.reviewCount ?? 0,
      latitude: viewModel.latitude,
      longitude: viewModel.longitude,
      isLiked: viewModel.isLiked
    )
  }
}
