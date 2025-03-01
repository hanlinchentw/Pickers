//
//  FilterOption.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/3/17.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import Foundation

enum FilterOption: Int, CaseIterable {
  case sort
  case price
  case distance
  case rating

  var icon: String? {
    switch self {
    case .price:
      "dollarsign"
    case .distance:
      "figure.run"
    case .rating:
      "star"
    default:
      nil
    }
  }

  var description: String {
    switch self {
    case .price:
      "Price"
    case .distance:
      "Distance"
    case .rating:
      "Rating"
    case .sort:
      "Sort"
    }
  }
}
