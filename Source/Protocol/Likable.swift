//
//  Likable.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/21.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

// protocol Likable {
//  var likeService: LikedCoreService { get }
//  func likeRestaurant(isLiked: Bool, restaurant: RestaurantViewObject)
// }
//
// extension Likable {
//  func likeRestaurant(isLiked: Bool, restaurant: RestaurantViewObject) {
//    let viewContext = CoreDataManager.sharedInstance.managedObjectContext
//    if isLiked {
//      try! likeService.deleteRestaurant(id: restaurant.id, in: viewContext)
//    } else {
//      let restaurantManagedObject = Restaurant(restaurant: restaurant)
//      try! likeService.addRestaurant(data: ["restaurant": restaurantManagedObject], in: viewContext)
//    }
//  }
// }
