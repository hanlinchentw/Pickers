//
//  RootNavigator.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/1/12.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import Foundation
import Observation
import SwiftUI

@Observable
class RootNavigator: Navigator {
  var path = NavigationPath()

  func navigateToDetail(id: String) {
    navigate(to: .detail)
  }
}
