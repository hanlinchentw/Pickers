//
//  AppCoordinator.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/3/31.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit
import SwiftUI

final class AppCoordinator: Coordinator {
	var childCoordinators: [Coordinator] = []
 
	var navigationController: UINavigationController
	
	init(window: UIWindow, navigationController: UINavigationController) {
		self.navigationController = navigationController
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
	}
	
	func start() {
		let root = UIHostingController(rootView: RootView())
		self.navigationController.setViewControllers([root], animated: false)
	}
}
