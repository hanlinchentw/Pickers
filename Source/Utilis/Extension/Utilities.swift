//
//  Utilities.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/7/3.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation

@discardableResult
func with<T>(_ item: T, update: (inout T) -> Void) -> T {
  var this = item
  update(&this)
  return this
}
