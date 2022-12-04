//
//  Inject.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/7/30.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

@propertyWrapper
class Inject<T> {
  var wrappedValue: T {
    return Resolver.sharedInstance.resolve(T.self)
  }

  init() {}
}
