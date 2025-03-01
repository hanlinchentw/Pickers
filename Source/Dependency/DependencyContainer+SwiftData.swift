//
//  DependencyContainer+SwiftData.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/2/28.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import Foundation
import SwiftData
import SwiftUI

// swiftlint:disable force_try
extension DependencyContainer {
  func registerPlaceModelContainer() {
    container.register(PlaceModelContainer.self) { _ in
      try! PlaceModelContainer()
    }
    .inObjectScope(.container)
  }
}

#if DEBUG
extension View {
  func dummySwiftDataModelContainer() -> some View {
    modelContainer(
      DependencyContainer
        .shared
        .getPreviewPlaceModelContainer()
        .modelContainer
    )
  }
}

extension DependencyContainer {
  func getPreviewPlaceModelContainer() -> PlaceModelContainer {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! PlaceModelContainer(configurations: config)
    try! container.insert(SDUserAddress(
      latitude: 23.5,
      longitude: 123.1,
      postalAddress: "中山北路, 43 號"
    ))
    for _ in 1..<6 {
      try! container.insert(SDPlaceModel.dummy)
    }

    for _ in 1..<12 {
      try! container.insert(SDFolder.dummy)
    }

    for _ in 1..<12 {
      try! container.insert(SDListModel.dummy)
    }

    return container
  }
}
#endif
// swiftlint:enable force_try
