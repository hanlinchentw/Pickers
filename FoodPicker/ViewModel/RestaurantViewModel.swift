//
//  RestaurantViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/18.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

class RestaurantViewModel: ObservableObject {
  @Inject var locationService: LocationService
  @Inject var selectCoreService: SelectedCoreService
  @Inject var likeCoreService: LikedCoreService
  @Published var dataSource: ListSectionData = .defaultState
  @Published var locationError: Error? = nil

  let option: BusinessService.SearchOption

  init(option: BusinessService.SearchOption) {
    self.option = option
  }

  func fetchData(resultCount: Int) async {
    guard let latitude = locationService.latitude, let longitude = locationService.longitude else {
      locationError = LoactionError.locationNotFound(message: "Coordinate found nil.")
      return
    }

    do {
      let task = BusinessService.createDataTask(lat: latitude, lon: longitude, option: option, limit: resultCount)
      let result = try await task.value
      DispatchQueue.main.async {
        self.dataSource = .init(loadingState: .loaded, viewObjects: result.map { RestaurantViewObject.init(business: $0) })
      }
    } catch {
      print("MainListViewModel.fetchData, error=\(error.localizedDescription)")
      self.dataSource = .errorState
    }
  }

  func selectRestaurant(isSelected: Bool, restaurant: RestaurantViewObject) {
    selectCoreService.toggleSelectState(isSelected: isSelected, restaurant: restaurant)
  }

  func likeRestaurant(isLiked: Bool, restaurant: RestaurantViewObject) {
    likeCoreService.toggleLikeState(isLiked: isLiked, restaurant: restaurant)
  }
}
// MARK: - ListSectionData
extension RestaurantViewModel {
  struct ListSectionData {
    var loadingState: LoadingState
    var viewObjects: Array<RestaurantViewObject>

    static var defaultState: Self {
      return .init(loadingState: .loading, viewObjects: [])
    }

    static var errorState: Self {
      return .init(loadingState: .error, viewObjects: [])
    }
  }
}
// MARK: - View utils
extension RestaurantViewModel {
  var showContent: () -> Bool {
    return {
      self.dataSource.loadingState != LoadingState.error
    }
  }

  var dataCount: () -> Int {
    return {
      if self.dataSource.loadingState == .loaded {
        return self.dataSource.viewObjects.count
      }
      if self.dataSource.loadingState == .loading {
        return 10 // Skeleton view
      }
      return 0
    }
  }
}
