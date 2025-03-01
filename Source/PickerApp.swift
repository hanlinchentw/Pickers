//
//  PickerApp.swift
//  Picker
//
//  Created by 陳翰霖 on 2025/3/1.
//

import SwiftUI

@main
struct PickerApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self)
	var appDelegate

  var containerWrapper: PlaceModelContainer { DependencyContainer.shared.getService() }

  var body: some Scene {
    WindowGroup {
      RootView()
        .modelContainer(containerWrapper.modelContainer)
    }
  }
}
