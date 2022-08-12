//
//  RestaurantEntityInterface.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/11.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import CoreData

protocol RestaurantEntityOperation {
  func getAllRestaurant() -> Array<Restaurant>
  func addRestaurant(id: String) throws
  func deleteRestaurant(id: String) throws
  func checkIfRestaurantExists(id: String) throws -> Bool
}
