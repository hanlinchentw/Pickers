//
//  AppCoordinator.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/3/31.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit
import SwiftUI

class AppCoordinator: Coordinator {
	var childCoordinators: [Coordinator] = []
	
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
//		 let tabVC = MainTabBarController()
		let tabVC = UIHostingController(rootView: HomeTabContainer())
		navigationController.setViewControllers([tabVC], animated: false)
	}
}
