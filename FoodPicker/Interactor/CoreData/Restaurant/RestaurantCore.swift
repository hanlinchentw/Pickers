//
//  RestaurantEntityInterface.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/11.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import CoreData

protocol RestaurantCore {
  func addRestaurant(data: [String: Any], in context: NSManagedObjectContext) throws
  func deleteRestaurant(id: String, in context: NSManagedObjectContext) throws
  func exists(id: String, in context: NSManagedObjectContext) throws -> Bool
}
