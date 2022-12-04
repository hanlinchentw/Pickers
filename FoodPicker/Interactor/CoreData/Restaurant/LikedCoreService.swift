//
//  LikedRestaurantCoreService.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/11.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import CoreData

class LikedCoreService: BaseCoreService<LikedRestaurant, LikedAddBehavior, LikedDeleteBehavior> {
  static let sharedInstance = LikedCoreService()
}

