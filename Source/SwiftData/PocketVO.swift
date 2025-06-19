//
//  PocketVO.swift
//  Picker
//
//  Created by 陳翰霖 on 2025/3/1.
//

import Foundation
import SwiftData

@Model
final class PocketVO {
  var id: String
  var name: String
	var createdAt: Date
	var places: [PlaceVO]

  init(pocket: Pocket) {
    self.id = pocket.id
    self.name = pocket.name
		self.createdAt = pocket.createdTime
		self.places = pocket.places.map { PlaceVO(from: $0) }
  }
}
