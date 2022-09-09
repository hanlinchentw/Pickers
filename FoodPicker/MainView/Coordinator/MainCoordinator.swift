//
//  MainCoordinator.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/5.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit
import SwiftUI

final class MainCoordinator: Coordinator, ObservableObject {
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController
  var mainVC: MainViewController?

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    self.mainVC = MainViewController.init()
    self.mainVC!.coordinator = self
    navigationController.pushViewController(self.mainVC!, animated: false)
  }

  func presentMapView() {
    self.mainVC!.mainPageMode = .map
  }

  func presentListView() {
    self.mainVC!.mainPageMode = .list
  }

  func presentMoreListView() {
    let moreListVC = UIHostingController(rootView: MoreListView())
    navigationController.pushViewController(moreListVC, animated: true)
  }
}
