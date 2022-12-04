//
//  RestaurantCoreService.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/14.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

class RestaurantCoreService: BaseCoreService<Restaurant, RestaurantAddBehavior, DeleteBehavior> {
  static let sharedInstance = RestaurantCoreService()
}
