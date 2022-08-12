//
//  SelectedRestaurantCoreService.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/11.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import CoreData

@objc
protocol RestaurantManagedObject where Self: NSManagedObject {
  var id: String { get set }
  var restaurant: Restaurant { get set }
}

class RestaurantCoreService<T: RestaurantManagedObject>: RestaurantEntityOperation {
  func getAllRestaurant() -> Array<Restaurant> {
    do{
      let selectedRestaurants: Array<T> = try T.allIn(NSManagedObjectContext.defaultContext())
      return selectedRestaurants.map { $0.restaurant }
    }catch{
      print("Debug: Failed to read data in core data model ... \(error.localizedDescription)")
    }
    return []
  }

  func addRestaurant(id: String) throws {
    let context = NSManagedObjectContext.defaultContext()
    let restaurant: Array<Restaurant> = try Restaurant.find(for: ["id": id], in: context)
    let selectedRestaurant = T.init(context: context)
    selectedRestaurant.id = id
    selectedRestaurant.restaurant = restaurant.first!
    try context.save()
  }

  func deleteRestaurant(id: String) throws {
    let context = NSManagedObjectContext.defaultContext()
    let selectedRestaurant : Array<T> = try T.find(for: ["id": id], in: context)
    for result in selectedRestaurant {
      result.delete(in: context)
    }
    try context.save()
  }

  func checkIfRestaurantExists(id: String) throws -> Bool {
    return try !SelectedRestaurant.find(for: ["id" : id], in: NSManagedObjectContext.defaultContext()).isEmpty
  }
}


