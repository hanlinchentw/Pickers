//
//  TabItems.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/6/28.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation
import UIKit

enum TabItems: Int, CaseIterable {
	case explore
	case wheel
	case pocket
	
	var item: UITabBarItem {
		switch self {
		case .explore:
			return feedBarItem
		case .wheel:
			return wheelBarItem
		case .pocket:
			return pocketBarItem
		}
	}
}

extension TabItems {

	private var imageInsets: UIEdgeInsets {
		UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
	}

	private var feedBarItem: UITabBarItem {
		let item = UITabBarItem(
			title: "",
			image: UIImage(resource: R.image.homeUnselectedS, with: nil),
			selectedImage: UIImage(resource: R.image.homeSelectedS, with: nil)
		)
		item.imageInsets = imageInsets
		return item
	}

	private var wheelBarItem: UITabBarItem {
		let item = UITabBarItem(
			title: "",
			image: UIImage(resource: R.image.spinActive, with: nil),
			selectedImage: nil
		)
		item.imageInsets = imageInsets
		return item
	}

	private var pocketBarItem: UITabBarItem {
		let item = UITabBarItem(
			title: "",
			image: UIImage(resource: R.image.favoriteUnselectedS, with: nil),
			selectedImage: nil
		)
		item.imageInsets = imageInsets
		return item
	}
}
