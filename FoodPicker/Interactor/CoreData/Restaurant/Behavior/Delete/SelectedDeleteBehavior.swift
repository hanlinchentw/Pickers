//
//  SelectedDeleteBehavior.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/14.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import CoreData

class SelectedDeleteBehavior: DeleteBehavior {
  override func delete(id: String, in context: NSManagedObjectContext) throws {
    let restaurant: Array<Restaurant> = try Restaurant.find(for: ["id": id], in: context)
    guard let restaurant = restaurant.first else {
      throw NSError(domain: #function, code: NSCoreDataError)
    }
    restaurant.isSelected = false
  }
}
