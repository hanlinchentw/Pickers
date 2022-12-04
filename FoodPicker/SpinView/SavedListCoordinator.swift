//
//  SavedListCoordinator.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/12.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit
import SwiftUI


class SavedListCoordinator: Coordinator, ObservableObject {
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController

	var applyList: (_ list: List) -> Void

	init(navigationController: UINavigationController, applyList: @escaping (_ list: List) -> Void) {
    self.navigationController = navigationController
		self.applyList = applyList
  }

	@MainActor
  func start() {
		let savedListView = SavedListView(applyList: applyList)
			.environmentObject(self)
			.environment(\.managedObjectContext, CoreDataManager.sharedInstance.managedObjectContext)

		let savedListVC = UIHostingController(rootView: savedListView)
		navigationController.pushViewController(savedListVC, animated: true)
		navigationController.navigationBar.isHidden = true
		navigationController.tabBarController?.tabBar.isHidden = true
	}
	
	@MainActor
  func pushToEditListView(list: List) {
    let editListView = EditListView(list: list).environment(\.managedObjectContext, CoreDataManager.sharedInstance.managedObjectContext)
    let editListVC = UIHostingController(rootView: editListView)
    navigationController.pushViewController(editListVC, animated: true)
  }
}
