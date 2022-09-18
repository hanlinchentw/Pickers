//
//  MainListViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/18.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

class MainListViewModel: ObservableObject {
  @Inject var restaurantCoreService: RestaurantCoreService
  @Inject var locationService: LocationService
  @Published var popularDataSource: ListSectionData = .defaultState
  @Published var nearybyDataSource: ListSectionData = .defaultState
  @Published var locationError: Error? = nil

  func fetchData() async {
    guard let latitude = locationService.latitude, let longitude = locationService.longitude else {
      locationError = LoactionError.locationNotFound(message: "Coordinate found nil.")
      return
    }

    for section in MainListViewModel.ListSection.allCases {
      do {
        let task = BusinessService.createDataTask(lat: latitude, lon: longitude, option: section.option, limit: section.resultCount)
        let result = try await task.value
        DispatchQueue.main.async {
          switch section {
          case .popular:
            self.popularDataSource = .init(loadingState: .loaded, viewObjects: result.map { RestaurantViewObject.init(business: $0) })
          case .nearby:
            self.nearybyDataSource = .init(loadingState: .loaded, viewObjects: result.map { RestaurantViewObject.init(business: $0) })
          }
        }
      } catch {
        print("MainListViewModel.fetchData, error=\(error.localizedDescription)")
        switch section {
        case .popular:
          self.popularDataSource = .errorState
          break
        case .nearby:
          self.nearybyDataSource = .errorState
          break
        }
      }
    }
  }
}
// MARK: - ListSection
extension MainListViewModel {
  enum ListSection: CaseIterable {
    case popular
    case nearby

    var option: BusinessService.SearchOption {
      switch self {
      case .popular: return .popular
      case .nearby: return .nearyby
      }
    }

    var resultCount: Int {
      switch self {
      case .popular: return 10
      case .nearby: return 30
      }
    }
  }
}
// MARK: - ListSectionData
extension MainListViewModel {
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
extension MainListViewModel {
  var showContent: (_ data: ListSectionData) -> Bool {
    return { data in
      data.loadingState != LoadingState.error
    }
  }

  var dataCount: (_ data: ListSectionData) -> Int {
    return { data in
      if data.loadingState == .loaded {
        return data.viewObjects.count
      }
      if data.loadingState == .loading {
        return 10 // Skeleton view
      }
      return 0
    }
  }
}

