//
//  RestaurantManagedObject.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/14.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import CoreData

@objc
protocol RestaurantManagedObject where Self: NSManagedObject {
  var id: String { get set }
}
