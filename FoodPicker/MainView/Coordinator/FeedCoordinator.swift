//
//  FeedCoordinator.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/5.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit
import SwiftUI

final class FeedCoordinator: Coordinator, ObservableObject {
	var childCoordinators = [Coordinator]()
	var navigationController: UINavigationController
	lazy var rootViewController = MainViewController()
	
	init(navigationController: UINavigationController = .init()) {
		self.navigationController = navigationController
	}
	
	func start() {
		navigationController.setViewControllers([rootViewController], animated: false)
	}
	
	func pop() {
		self.navigationController.popViewController(animated: true)
	}
	
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
	
	@MainActor
	func presentSearchViewController() {
		let nav = UINavigationController()
		nav.modalPresentationStyle = .overFullScreen
		nav.modalTransitionStyle = .crossDissolve
		
		let searchCoordinator = SearchCoordinator(navigationController: nav)
		searchCoordinator.parent = self
		self.childCoordinators.append(searchCoordinator)
		searchCoordinator.start()
		
		PresentHelper.topViewController?.present(nav, animated: true)
	}
	
	func childDidFinish(_ child: Coordinator?) {
		for (index, coordinator) in childCoordinators.enumerated() {
			if coordinator === child {
				childCoordinators.remove(at: index)
				break
			}
		}
	}
}
