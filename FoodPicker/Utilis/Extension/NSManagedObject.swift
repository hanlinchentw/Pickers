//
//  NSManagedObject.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/11.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit
import CoreData

extension NSManagedObjectContext {
  static func defaultContext() -> NSManagedObjectContext {
    return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  }
}

extension NSManagedObject {
  static func allIn<T: NSManagedObject>(_ context: NSManagedObjectContext) throws -> Array<T>  {
    return try self.fetchWithCondition(for: nil, in: context)
  }
  static func find<T: NSManagedObject>(for condition: Dictionary<String, String>, in context: NSManagedObjectContext) throws -> Array<T> {
    return try self.fetchWithCondition(for: condition, in: context)
  }

  static func save(in context: NSManagedObjectContext) throws {
    return try context.save()
  }

  func delete(in context: NSManagedObjectContext) {
    return context.delete(self)
  }

  static func deleteAll(in context: NSManagedObjectContext) throws {
    try self.allIn(context).forEach { result in
      result.delete(in: context)
    }
  }
}

extension NSManagedObject {
  static var entityName: String {
    return NSStringFromClass(self)
  }

  static func fetchWithCondition<T>(for condition: Dictionary<String, String>?, in context: NSManagedObjectContext) throws -> Array<T> {
    let request = self.createFetchRequestIn(context)
    request.returnsObjectsAsFaults = false
    if let condition = condition {
      let predicates: Array<NSPredicate> = condition.map { key, value in
        return NSPredicate(format: "%1$@ == %2$@", argumentArray: [key, value])
      }
      let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
      request.predicate = compoundPredicate
    }
    return try context.fetch(request) as! Array<T>
  }

  static func createFetchRequestIn(_ context: NSManagedObjectContext) -> NSFetchRequest<NSFetchRequestResult> {
    let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>()
    let entity = NSEntityDescription.entity(forEntityName: self.entityName, in: context)
    request.entity = entity
    return request
  }
}

