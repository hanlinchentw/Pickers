//
//  PickerApp.swift
//  Picker
//
//  Created by 陳翰霖 on 2025/3/1.
//

import SwiftData
import SwiftUI

@main
struct PickerApp: App {
  var containerWrapper: PlaceModelContainer { DependencyContainer.shared.getService() }

  init() {
    DependencyContainer.shared.registerAllComponents()
  }

  var body: some Scene {
    WindowGroup {
      RootView()
        .modelContainer(containerWrapper.modelContainer)
    }
  }
}
