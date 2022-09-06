//
//  TabConstants.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/7/30.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit
import SwiftUI
import CoreData
final class MainTabBarConstants {
  enum TabItemType {
    case main
    case favorite
    case spin

    var viewController: UIViewController {
      switch self {
      case .main:
        let nav = UINavigationController()
        let coordinator = MainCoordinator(navigationController: nav)
        coordinator.start()
        return nav
      case .favorite: return UIHostingController(rootView: FavoriteView().environment(\.managedObjectContext, CoreDataManager.sharedInstance.managedObjectContext))
      case .spin: return UINavigationController(rootViewController: SpinViewController.init())
      }
    }

    var defaultTabItemImage: String {
      switch self {
      case .main: return MainTabBarConstants.homeUnselectedTabImage
      case .favorite: return MainTabBarConstants.favoriteUnselectedTabImage
      case .spin: return ""
      }
    }

    var selectedTabItemImage: String {
      switch self {
      case .main: return MainTabBarConstants.homeSelectedTabImage
      case .favorite: return MainTabBarConstants.favoriteSelectedTabImage
      case .spin: return ""
      }
    }
  }

  static let homeUnselectedTabImage = "homeUnselectedS"
  static let homeSelectedTabImage = "homeSelectedS"

  static let searchUnselectedTabImage = "searchUnselectedS"
  static let searchSelectedTabImage = "searchSelectedS"

  static let favoriteUnselectedTabImage = "favoriteUnselectedS"
  static let favoriteSelectedTabImage = "icnTabHeartSelected"

  static let SpinTabImage = "spinActive"

  static let tabImage = "bar"
}

