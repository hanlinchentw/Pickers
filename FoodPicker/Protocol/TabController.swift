//
//  TabController.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/10/22.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit

protocol Tab {
	static var viewControllers: Array<UIViewController> { get }
}
protocol TabController {
	associatedtype TabType: Tab
	var displayViewControllers: Array<UIViewController> { get }
}

extension TabController {
	var displayViewControllers: Array<UIViewController> {
		TabType.viewControllers
	}
}
