//
//  DeleteBehavior.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/14.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import CoreData

protocol DeleteBehaviorInterface {
  func delete(id: String, in context: NSManagedObjectContext) throws
}

class DeleteBehavior: DeleteBehaviorInterface {
  required init() {}

  func delete(id: String, in context: NSManagedObjectContext) throws {}
}

