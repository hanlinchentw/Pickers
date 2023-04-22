//
//  WheelCoordinator.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/19.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit

final class WheelCoordinator: Coordinator {
	var childCoordinators: [Coordinator] = []
	
	var navigationController: UINavigationController
	
	lazy var rootViewController = WheelViewController()
	
	init() {
		self.navigationController = UINavigationController()
	}
	
	func start() {
		navigationController.viewControllers = [rootViewController]
	}
}
