//
//  FeedCoordinator.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/5.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit
import SwiftUI

final class ExploreCoordinator: Coordinator, ObservableObject {
	var childCoordinators = [Coordinator]()

	var navigationController: UINavigationController
//	lazy var viewModel = ExploreViewModelImpl()
//	lazy var rootViewController: UIViewController = UIHostingController(rootView: ExplorerView(viewModel: ExploreViewModelImpl()))
	
	init(navigationController: UINavigationController = .init()) {
		self.navigationController = navigationController
	}
	
	func start() {
//		navigationController.setViewControllers([rootViewController], animated: false)
	}
	
	func pop() {
		self.navigationController.popViewController(animated: true)
	}
	
	func pushToMoreListView() {
	}
	
	@MainActor
	func pushToDetailView(id: String) {
		let detailView = DetailController(id: id)
		navigationController.pushViewController(detailView, animated: true)
	}
	
	@MainActor
	func presentSearchViewController() {
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
