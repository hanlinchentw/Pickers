//
//  SelectedRestaurantCoreService.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/11.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import CoreData

class BaseCoreService<Object: RestaurantManagedObject, Add: AddBehavior, Delete: DeleteBehavior>: RestaurantCore {
  private var addBehavior: Add
  private var deleteBehavior: Delete

  init() {
    self.addBehavior = Add.init()
    self.deleteBehavior = Delete.init()
  }

  func addRestaurant(data: [String: Any], in context: NSManagedObjectContext) throws {
    try addBehavior.add(data: data, in: context)
  }

  func deleteRestaurant(id: String, in context: NSManagedObjectContext) throws {
    try deleteBehavior.delete(id: id, in: context)

    // common delete
    let objects : Array<Object> = try Object.find(for: ["id": id], in: context)
    for result in objects {
      result.delete(in: context)
    }
    try context.save()
  }

  func exists(id: String, in context: NSManagedObjectContext) throws -> Bool {
    return try !Object.find(for: ["id" : id], in: context).isEmpty
  }
}


