//
//  WheelInteractor.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/8/18.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import Foundation
import SwiftData

final class WheelInteractor {
  var modelContainer: PlaceModelContainer { DependencyContainer.shared.getService() }

  func fetchLists() throws -> [SDListModel] {
    let sortDesc = SortDescriptor<SDListModel>(\.date)
    let fetchDescriptor = FetchDescriptor<SDListModel>(sortBy: [sortDesc])
    return try modelContainer.fetch(descriptor: fetchDescriptor)
  }

  func createEmptyList(name: String) throws {
    let model = SDListModel(id: UUID().uuidString, name: name, item: [], date: .now)
    try modelContainer.insert(model)
  }
}
