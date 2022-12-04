//
//  RestaurantAddBehavior.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/14.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import CoreData

class RestaurantAddBehavior: AddBehavior {
  override func add(data: [String: Any], in context: NSManagedObjectContext) throws {
    guard let businesses = data["businesses"] as? Array<Business> else {
      throw NSError(domain: "\(#function), business not found", code: NSCoreDataError)
    }
    for business in businesses {
      if try !Restaurant.find(for: ["id": business.id], in: context).isEmpty {
        print("is alrady Existed")
        continue
      }

      let restaurant = Restaurant(business: business, context: context)

      let isLiked = try !LikedRestaurant.find(for: ["id": business.id], in: context).isEmpty
      let isSelected = try !SelectedRestaurant.find(for: ["id": business.id], in: context).isEmpty
      restaurant.isLiked = isLiked
      restaurant.isSelected = isSelected

      try context.save()
      print("RestaurantAddBehavior.add business: \(business.name)")
    }
    print("\(#function) save Successfully.")
  }
}
