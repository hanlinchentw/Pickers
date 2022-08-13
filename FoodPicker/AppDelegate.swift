//
//  AppDelegate.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/5.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    NetworkMonitor.shared.startMonitoring()
    Resolver.sharedInstance.register(type: BusinessService.self, dependency: BusinessService.sharedInstance)
    Resolver.sharedInstance.register(type: CoredataService.self, dependency: CoredataService.sharedInstance)
    Resolver.sharedInstance.register(type: SelectedRestaurantCoreService.self, dependency: SelectedRestaurantCoreService.sharedInstance)
    Resolver.sharedInstance.register(type: LikedRestaurantCoreService.self, dependency: LikedRestaurantCoreService.sharedInstance)
    return true
  }

  // MARK: UISceneSession Lifecycle
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
  //MARK: -  Core data Stack
  lazy var persistentContainer: NSPersistentContainer = {
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

  func saveContext(){
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      }catch{
        let err = error as NSError
        print("DEBUG: Houston, we have problem with save core data!!")
        fatalError("\(err), \(err.userInfo)")
      }
    }
  }
}
