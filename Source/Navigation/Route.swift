//
//  Route.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/1/12.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import Foundation

enum Route {
  case detail

  var name: String {
    switch self {
    case .detail:
      "Detail"
    }
  }
}

extension Route: Hashable {}
