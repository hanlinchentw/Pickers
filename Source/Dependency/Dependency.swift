//
//  Dependency.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/10/6.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import Foundation

@propertyWrapper
struct Dependency<T> {
  var wrappedValue: T {
    DependencyContainer.shared.getService()
  }
}
