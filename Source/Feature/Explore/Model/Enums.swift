//
//  Enums.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/4/2.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import Foundation

enum SortOption: String {
  case distance = "Distance"
}

enum BrowseMode {
  case map
  case list

  func toggle() -> BrowseMode {
    self == .map ? .list : .map
  }
}
