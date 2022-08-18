//
//  CoreDataManager.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/14.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class CoreDataManager {
  // MARK: - Properties
  static let sharedInstance = CoreDataManager()
  // MARK: - Save
  func saveContext () {
    self.managedObjectContext.performAndWait {
      if managedObjectContext.hasChanges {
        do {
          try self.managedObjectContext.save()
        } catch {
          // Replace this implementation with code to handle the error appropriately.
          // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
          let nserror = error as NSError
          fatalError("CoreData: Unresolved error \(nserror), \(nserror.userInfo)")
        }
      }
    }
  }
  private(set) lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Pickers")
    container.persistentStoreDescriptions.forEach { storeDesc in
      storeDesc.shouldMigrateStoreAutomatically = true
      storeDesc.shouldInferMappingModelAutomatically = true
    }

    container.loadPersistentStores { description, error in
      if let error = error {
        fatalError("Unable to load persistent stores: \(error)")
      }
    }
    return container
  }()

  var managedObjectContext: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
}
