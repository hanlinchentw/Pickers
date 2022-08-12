//
//  TabConstants.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/7/30.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit

final class MainTabBarConstants {
  static let homeUnselectedTabImage = "homeUnselectedS"
  static let homeSelectedTabImage = "homeSelectedS"

  static let searchUnselectedTabImage = "searchUnselectedS"
  static let searchSelectedTabImage = "searchSelectedS"

  static let favoriteUnselectedTabImage = "favoriteUnselectedS"
  static let favoriteSelectedTabImage = "icnHeartXs"

  static let SpinTabImage = "spinActive"

  static let tabImage = "bar"
}

enum TabItemType {
  case main
  case search
  case favorite
  case spin

  var viewController: UIViewController.Type {
    switch self {
    case .main: return MainPageController.self
    case .search: return SearchTableViewController.self
    case .favorite: return FavoriteController.self
    case .spin: return ActionViewController.self
    }
  }

  var defaultTabItemImage: String {
    switch self {
    case .main: return MainTabBarConstants.homeUnselectedTabImage
    case .search: return MainTabBarConstants.searchUnselectedTabImage
    case .favorite: return MainTabBarConstants.favoriteUnselectedTabImage
    case .spin: return ""
    }
  }

  var selectedTabItemImage: String {
    switch self {
    case .main: return MainTabBarConstants.homeSelectedTabImage
    case .search: return MainTabBarConstants.searchSelectedTabImage
    case .favorite: return MainTabBarConstants.favoriteSelectedTabImage
    case .spin: return ""
    }
  }
}
