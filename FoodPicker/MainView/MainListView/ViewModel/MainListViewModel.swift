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
  @Published var popularDataSource = ListSectionData.defaultState
  @Published var nearybyDataSource = ListSectionData.defaultState

  @MainActor func fetchData() async {
    for section in MainListViewModel.ListSection.allCases {
      do {
        guard let latitude = locationService.latitude, let longitude = locationService.longitude else {
          throw LoactionError.locationNotFound(message: "Coordinate found nil.")
        }
        let task = BusinessService.createDataTask(lat: latitude, lon: longitude, option: section.option, limit: section.resultCount)
        let result = try await task.value
        DispatchQueue.main.async {
          switch section {
          case .popular:
            self.popularDataSource = .init(loadingState: .loaded, dataSource: result.map { RestaurantViewObject.init(business: $0) })
            break
          case .nearby:
            self.nearybyDataSource = .init(loadingState: .loaded, dataSource: result.map { RestaurantViewObject.init(business: $0) })
            break
          }
        }
      } catch {
        print("MainListViewModel.fetchData, error=\(error.localizedDescription)")
      }
    }
  }
}

extension MainListViewModel {
  enum ListSection: CaseIterable {
    case popular
    case nearby

    var option: BusinessService.RestaurantSorting {
      switch self {
      case .popular: return BusinessService.RestaurantSorting.popular
      case .nearby: return BusinessService.RestaurantSorting.all
      }
    }

    var resultCount: Int {
      switch self {
      case .popular: return 10
      case .nearby: return 20
      }
    }
  }
}

extension MainListViewModel {
  struct ListSectionData {
    var loadingState: LoadingState
    var dataSource: Array<RestaurantViewObject>

    static var defaultState: Self {
      return .init(loadingState: .loading, dataSource: [])
    }
  }
}
