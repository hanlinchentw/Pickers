//
//  LikedAddBehavior.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/14.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import CoreData

class LikedAddBehavior: AddBehavior {
  override func add(data: [String: Any], in context: NSManagedObjectContext) throws {
    guard let restaurant = data["restaurant"] as? Restaurant else {
      throw NSError(domain: "\(#function), business not found", code: NSCoreDataError)
    }
    restaurant.isLiked = true

    let likedRestaurant = LikedRestaurant.init(context: context)
    likedRestaurant.id = restaurant.id
    likedRestaurant.restaurant = restaurant
    try context.save()
  }
}
