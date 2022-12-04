//
//  TabConstants.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/7/30.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit
import SwiftUI
import CoreData

enum MainTab: Tab, CaseIterable {
	case main
	case spin
	case favorite

	static let homeUnselectedTabImage = "homeUnselectedS"
	static let homeSelectedTabImage = "homeSelectedS"

	static let favoriteUnselectedTabImage = "favoriteUnselectedS"
	static let favoriteSelectedTabImage = "icnTabHeartSelected"

	private var viewController: UIViewController {
		switch self {
		case .main:
			let nav = UINavigationController()
			nav.tabBarItem.image = UIImage(named: Self.homeUnselectedTabImage)
			nav.tabBarItem.selectedImage = UIImage(named: Self.homeSelectedTabImage)
			let coordinator = MainCoordinator(navigationController: nav)
			coordinator.start()
			return nav
		case .favorite:
			let favoriteVC = UIHostingController(rootView: FavoriteView().environment(\.managedObjectContext, CoreDataManager.sharedInstance.managedObjectContext))
			favoriteVC.tabBarItem.image = UIImage(named: Self.favoriteUnselectedTabImage)
			favoriteVC.tabBarItem.selectedImage = UIImage(named: Self.favoriteSelectedTabImage)
			return favoriteVC
		case .spin:
			return UINavigationController(rootViewController: SpinViewController())
		}
	}
	
	static var viewControllers: Array<UIViewController> {
		MainTab.allCases.map {
			let vc = $0.viewController
			vc.tabBarItem.imageInsets = UIEdgeInsets(top: 16, left: 0, bottom: -16, right: 0)
			return vc
		}
	}
}
