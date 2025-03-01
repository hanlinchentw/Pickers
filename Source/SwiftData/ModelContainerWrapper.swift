//
//  ModelContainerWrapper.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/2/28.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import Foundation
import SwiftData

final class PlaceModelContainer {
  let modelContainer: ModelContainer

  init() throws {
    let storeURL = URL.documentsDirectory.appending(path: "pickers.sqlite")
    let config = ModelConfiguration(url: storeURL)
    self.modelContainer = try ModelContainer(
      for: SDPlaceModel.self, SDUserAddress.self, SDFolder.self, SDListModel.self,
      configurations: config
    )
  }

  init(configurations: ModelConfiguration) throws {
    self.modelContainer = try ModelContainer(
      for: SDPlaceModel.self, SDUserAddress.self, SDFolder.self, SDListModel.self,
      configurations: configurations
    )
  }

  func context() -> ModelContext {
    ModelContext(modelContainer)
  }

  func insert(_ model: some PersistentModel) throws {
    let context = context()
    context.insert(model)
    try context.save()
  }

  func fetch<T: PersistentModel>(descriptor: FetchDescriptor<T>) throws -> [T] {
    try context().fetch(descriptor)
  }

  func fetchCount<T: PersistentModel>(_ type: T.Type, descriptor: FetchDescriptor<T>) throws -> Int {
    try context().fetchCount(descriptor)
  }
}
