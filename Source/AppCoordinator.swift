//
//  AppCoordinator.swift
//  Picker
//
//  Created by 陳翰霖 on 2023/3/31.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import SwiftUI
import UIKit

final class AppCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = []

  var navigationController: UINavigationController

  init(window: UIWindow, navigationController: UINavigationController) {
    self.navigationController = navigationController
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
  }

  func start() {
    let containerWrapper: PlaceModelContainer = DependencyContainer.shared.getService()
    Task {
      let root = await UIHostingController(
        rootView: RootView().modelContainer(containerWrapper.modelContainer)
      )
      await navigationController.setViewControllers([root], animated: false)
    }
  }
}
