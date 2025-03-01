//
//  SDListModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/8/10.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class SDListModel {
  var id: String
  var name: String
  var item: [SDPlaceModel]
  var date: Date

  init(id: String, name: String, item: [SDPlaceModel], date: Date) {
    self.id = id
    self.name = name
    self.item = item
    self.date = date
  }
}

extension SDListModel {
  static var dummy: SDListModel {
    .init(id: UUID().uuidString, name: "Test", item: [.dummy, .dummy, .dummy], date: Date())
  }
}
