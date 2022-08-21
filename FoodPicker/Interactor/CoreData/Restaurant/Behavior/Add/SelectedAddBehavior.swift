//
//  SelectedAddBehavior.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/14.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import CoreData

class SelectedAddBehavior: AddBehavior {
  override func add(data: [String: Any], in context: NSManagedObjectContext) throws {
    guard let restaurant = data["restaurant"] as? Restaurant else {
      throw NSError(domain: "\(#function), business not found", code: NSCoreDataError)
    }
    restaurant.isSelected = true

    let selectedRestaurant = SelectedRestaurant.init(context: context)
    selectedRestaurant.id = restaurant.id
    selectedRestaurant.restaurant = restaurant
    try context.save()
  }
}
