//
//  Folder.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/4/6.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import Foundation
import Observation
import SwiftData

@Model
final class SDFolder {
  let id: String
  let name: String

  init(id: String, name: String) {
    self.id = id
    self.name = name
  }
}

extension SDFolder {
  static var dummy: SDFolder {
    .init(id: UUID().uuidString, name: "Test\(Int.random(in: 0...100))")
  }
}
