//
//  TabBarController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/19.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
  private var previousController: UIViewController?

  override init(nibName _: String?, bundle _: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    delegate = self
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension TabBarController: UITabBarControllerDelegate {
  func tabBarController(_: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    if previousController == nil {
      previousController = viewController
    }

    if previousController == viewController {
      if let nav = viewController as? UINavigationController,
         nav.viewControllers.count < 2,
         let controller = nav.viewControllers.first as? Scrollable {
        controller.scrollOnTop()
      }
    }
    previousController = viewController
    return true
  }
}
