//
//  SelectedRestaurantCoreService.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/11.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import CoreData

class SelectedCoreService: BaseCoreService<SelectedRestaurant, SelectedAddBehavior, SelectedDeleteBehavior> {
  static let sharedInstance = SelectedCoreService()

  func toggleSelectState(isSelected: Bool, restaurant: RestaurantViewObject) {
    let viewContext = CoreDataManager.sharedInstance.managedObjectContext
    if (isSelected) {
      try! deleteRestaurant(id: restaurant.id, in: viewContext)
    } else {
      let restaurantManagedObject = Restaurant(restaurant: restaurant)
      try! addRestaurant(data: ["restaurant": restaurantManagedObject], in: viewContext)
    }
  }
}
