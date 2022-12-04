//
//  Resolver.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/7/30.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

class Resolver {
  var dependencies: Dictionary<String, Any> = [:]

  static let sharedInstance = Resolver()

  func register<T>(type: T.Type, dependency: T) {
    let key = String.init(describing: type)
    self.dependencies[key] = dependency
  }

  func resolve<T>(_ type: T.Type) -> T {
    let key = String.init(describing: type)
    guard let dependency = dependencies[key] as? T else {
      fatalError("Fatal: \(type) not injected.")
    }
    return dependency
  }
}
