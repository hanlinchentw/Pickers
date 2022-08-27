//
//  BottomSheetPresenter.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/26.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

class BottomSheetViewModel {
  @Inject var coreService: SelectedCoreService

  @Published var list: List?
  @Published var restaurants: Array<Restaurant> = []
  @Published var isRefresh: Bool = false

  func refresh() {
    if let selectedRestaurants = try? SelectedRestaurant.allIn(CoreDataManager.sharedInstance.managedObjectContext) as? Array<SelectedRestaurant> {
      self.restaurants = selectedRestaurants.map { $0.restaurant }
    }
    isRefresh = true
  }

  func didTapActionButton(_ target: Restaurant) {
    let restaurant = restaurants.first(where: { $0.id == target.id })
    guard let restaurant = restaurant else {
      return
    }
    if restaurant.isSelected {
      try? coreService.deleteRestaurant(id: restaurant.id, in: CoreDataManager.sharedInstance.managedObjectContext)
      restaurant.isSelected.toggle()
    } else {
      try? coreService.addRestaurant(data: ["restaurant": restaurant], in: CoreDataManager.sharedInstance.managedObjectContext)
    }
//    isRefresh = true
  }
}
