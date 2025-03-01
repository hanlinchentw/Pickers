//
//  AppDelegate.swift
//  Picker
//
//  Created by 陳翰霖 on 2025/3/1.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    DependencyContainer.shared.registerAllComponents()
    return true
  }
}
