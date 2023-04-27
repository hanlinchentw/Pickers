//
//  TabCoordinator.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/19.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation
import UIKit

class TabCoordinator: Coordinator {
	var childCoordinators: [Coordinator] = []
	
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		showTabBar()
	}
	
	func showTabBar() {
		let viewModel = TabCoordinatorViewModel()
		
		// feedCoordinator
		let feedCoordinator = ExploreCoordinator()
		feedCoordinator.start()
		feedCoordinator.rootViewController.tabBarItem = viewModel.feedBarItem
		addCoordinator(feedCoordinator)
		
		// wheelCoordinator
		let wheelCoordinator = WheelCoordinator()
		wheelCoordinator.start()
		wheelCoordinator.rootViewController.tabBarItem = viewModel.wheelBarItem
		addCoordinator(wheelCoordinator)
		
		// favoriteCoordinator
		let pocketCoordinator = PocketCoordinator()
		pocketCoordinator.start()
		pocketCoordinator.rootViewController.tabBarItem = viewModel.pocketBarItem
		addCoordinator(pocketCoordinator)
		
		let tabBarController = MainTabBarController()
		tabBarController.tabBar.isTranslucent = false
		
		tabBarController.viewControllers = [
			feedCoordinator.navigationController,
			wheelCoordinator.navigationController,
			pocketCoordinator.navigationController
		]
		
		navigationController.setViewControllers([tabBarController], animated: false)
		navigationController.setNavigationBarHidden(true, animated: false)
	}
}

