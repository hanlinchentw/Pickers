//
//  Selectable.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/21.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

//
// protocol Selectable {
//  var selectService: SelectedCoreService { get }
//  func selectRestaurant(isSelected: Bool, restaurant: RestaurantViewObject)
// }
//
// extension Selectable {
//  func selectRestaurant(isSelected: Bool, restaurant: RestaurantViewObject) {
//    let viewContext = CoreDataManager.sharedInstance.managedObjectContext
//    if isSelected {
//      try! selectService.deleteRestaurant(id: restaurant.id, in: viewContext)
//    } else {
//      let restaurantManagedObject = Restaurant(restaurant: restaurant)
//      try! selectService.addRestaurant(data: ["restaurant": restaurantManagedObject], in: viewContext)
//    }
//  }
// }
