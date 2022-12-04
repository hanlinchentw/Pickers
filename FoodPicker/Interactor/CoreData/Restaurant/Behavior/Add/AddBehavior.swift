//
//  AddBehavior.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/14.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import CoreData

protocol AddBehaviorInterface {
  func add(data: [String: Any], in context: NSManagedObjectContext) throws
}

class AddBehavior: AddBehaviorInterface {
  required init() {}

  func add(data: [String: Any], in context: NSManagedObjectContext) throws {
    throw NSError(domain: "\(#function) should be implemented in child class", code: 0)
  }
}
