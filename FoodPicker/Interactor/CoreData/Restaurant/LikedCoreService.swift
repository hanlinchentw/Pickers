//
//  LikedRestaurantCoreService.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/11.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import CoreData

class LikedCoreService: BaseCoreService<LikedRestaurant, LikedAddBehavior, LikedDeleteBehavior> {
  static let sharedInstance = LikedCoreService()

  func toggleLikeState(isLiked: Bool, restaurant: RestaurantViewObject) {
    let viewContext = CoreDataManager.sharedInstance.managedObjectContext
    if (isLiked) {
      try! deleteRestaurant(id: restaurant.id, in: viewContext)
    } else {
      let restaurantManagedObject = Restaurant(restaurant: restaurant)
      try! addRestaurant(data: ["restaurant": restaurantManagedObject], in: viewContext)
    }
  }
}

