//
//  PlacePocketViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/30.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation

struct PlacePocketViewModel {
  var id: String
  var name: String
  var items: [PlaceViewModel]
}

extension PlacePocketViewModel: Equatable {
  static func == (lhs: PlacePocketViewModel, rhs: PlacePocketViewModel) -> Bool {
    lhs.id == rhs.id && lhs.name == rhs.name && lhs.items == rhs.items
  }
}
