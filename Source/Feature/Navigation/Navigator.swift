//
//  Navigator.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/1/12.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import Foundation
import SwiftUI

protocol Navigator: AnyObject {
  var path: NavigationPath { get set }
  func navigate(to: Route)
  func pop()
  func popToTop()
}

extension Navigator {
  func navigate(to: Route) {
    path.append(to)
  }

  func pop() {
    path.removeLast()
  }

  func popToTop() {
    path.removeLast(path.count)
  }
}
