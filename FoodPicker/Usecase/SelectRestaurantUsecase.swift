//
//  SelectRestaurantUsecase.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/18.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

class SelectRestaurantUsecase {
  static let viewContext = CoreDataManager.sharedInstance.managedObjectContext
  @Inject var selectedCoreService: SelectedCoreService

  func toggleSelectState(restaurant: RestaurantViewObject) {
    if (checkIsRestaurantSelected(restaurant.id)) {
      try! selectedCoreService.deleteRestaurant(id: restaurant.id, in: Self.viewContext)
    } else {
      let restaurantManagedObject = Restaurant(restaurant: restaurant)
      try! selectedCoreService.addRestaurant(data: ["restaurant": restaurantManagedObject], in: Self.viewContext)
    }
  }
  
  func checkIsRestaurantSelected(_ id: String) -> Bool {
    if let isSelected = try? selectedCoreService.exists(id: id, in: Self.viewContext) {
      return isSelected
    }
    return false
  }
}
