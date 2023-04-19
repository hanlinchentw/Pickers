//
//  SearchCoordinator.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/10/8.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit

class SearchCoordinator: Coordinator {
	var parent: FeedCoordinator?
	var childCoordinators = [Coordinator]()
	var navigationController: UINavigationController

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
		let searchVC = SearchViewController()
		searchVC.coordinator = self
		self.navigationController.pushViewController(searchVC, animated: true)
	}
	
	func didFinishSearching() {
		self.navigationController.dismiss(animated: true)
	}
}
