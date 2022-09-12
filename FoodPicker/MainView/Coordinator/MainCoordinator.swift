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

  @MainActor
  func pop() {
    self.navigationController.popViewController(animated: true)
  }

  @MainActor
  func presentMapView() {
    self.mainVC!.mainPageMode = .map
  }

  @MainActor
  func presentListView() {
    self.mainVC!.mainPageMode = .list
  }

  @MainActor
  func pushToMoreListView() {
    let moreListVC = UIHostingController(rootView: MoreListView()
      .environmentObject(self)
      .environment(\.managedObjectContext, CoreDataManager.sharedInstance.managedObjectContext)
    )
    navigationController.tabBarController?.tabBar.isHidden = true
    navigationController.pushViewController(moreListVC, animated: true)
  }

  @MainActor
  func pushToDetailView(id: String) {
    let detailView = DetailController(id: id)
    navigationController.pushViewController(detailView, animated: true)
  }
}
