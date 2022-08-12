//
//  MainListViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/9.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import RxSwift

class MainListViewModel: ViewModelType {
  typealias Input = MainListViewModelInputType
  typealias Output = MainListViewModelOutputType

  struct MainListViewModelInputType {}
  struct MainListViewModelOutputType {}

  var inputs: Input
  var outputs: Output

  @Inject var businessService: BusinessService
  @Inject var locationService: LocationService

  init() {
    self.inputs = Input.init()
    self.outputs = Output.init()
  }

  func fetchPopularRestaurant() -> Single<MainListSectionViewObject> {
    guard let coordinate = locationService.coordinate else { return Single.error(LoactionError.locationNotFound) }
    print("ViewModel.fetchRestaurants >>>>> coordinate \(coordinate)")
    return businessService.getBusinesses(lat: coordinate.latitude, lon: coordinate.longitude, option: RestaurantSorting.popular)
      .map { businesses -> MainListSectionViewObject in
        let cardViewObjects = businesses.map { RestaurantViewObject(business: $0) }
        return MainListSectionViewObject(section: .popular, content: cardViewObjects)
      }
  }

  func fetchAllRestaurant() -> Single<MainListSectionViewObject> {
    guard let coordinate = locationService.coordinate else { return Single.error(LoactionError.locationNotFound) }
    print("ViewModel.fetchRestaurants >>>>> coordinate \(coordinate)")
    return businessService.getBusinesses(lat: coordinate.latitude, lon: coordinate.longitude, option: RestaurantSorting.all)
      .map { businesses in
        let cardViewObjects = businesses.map { RestaurantViewObject(business: $0) }
        return MainListSectionViewObject(section: .all, content: cardViewObjects)
      }
  }
}
