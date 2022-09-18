//
//  LikeRestaurantUsecase.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/18.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

class LikeRestaurantUsecase {
  static let viewContext = CoreDataManager.sharedInstance.managedObjectContext
  @Inject var likedCoreService: LikedCoreService

  func toggleLikeState(restaurant: RestaurantViewObject) {
    if (checkIsRestaurantLiked(restaurant.id)) {
      try! likedCoreService.deleteRestaurant(id: restaurant.id, in: Self.viewContext)
    } else {
      let restaurantManagedObject = Restaurant(restaurant: restaurant)
      try! likedCoreService.addRestaurant(data: ["restaurant": restaurantManagedObject], in: Self.viewContext)
    }
  }

  func checkIsRestaurantLiked(_ id: String) -> Bool {
    if let isLiked = try? self.likedCoreService.exists(id: id, in: Self.viewContext) {
      return isLiked
    }
    return false
  }
}
