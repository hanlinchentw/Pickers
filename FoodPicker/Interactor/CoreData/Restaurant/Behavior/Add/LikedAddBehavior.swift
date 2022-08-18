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
    guard let id = data["id"] as? String else {
      throw NSError(domain: "\(#function) id not found.", code: 0)
    }
    let restaurant: Array<Restaurant> = try Restaurant.find(for: ["id": id], in: context)
    let likedRestaurant = LikedRestaurant.init(context: context)
    guard let restaurant = restaurant.first else {
      throw NSError(domain: #function, code: NSCoreDataError)
    }
    restaurant.isLiked = true
    likedRestaurant.id = id
    likedRestaurant.restaurant = restaurant
    try context.save()
  }
}
