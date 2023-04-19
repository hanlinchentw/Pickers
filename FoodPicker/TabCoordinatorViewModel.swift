//
//  TabCoordinatorViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/4/19.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import UIKit

final class TabCoordinatorViewModel {
	var imageInsets: UIEdgeInsets {
		UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
	}

	var feedBarItem: UITabBarItem {
		let item = UITabBarItem(
			title: "",
			image: UIImage(resource: R.image.homeUnselectedS, with: nil),
			selectedImage: UIImage(resource: R.image.homeSelectedS, with: nil)
		)
		item.imageInsets = imageInsets
		return item
	}
	
	var wheelBarItem: UITabBarItem {
		let item = UITabBarItem(
			title: "",
			image: nil,
			selectedImage: nil
		)
		item.imageInsets = imageInsets
		return item
	}
	
	var pocketBarItem: UITabBarItem {
		let item = UITabBarItem(
			title: "",
			image: UIImage(resource: R.image.favoriteUnselectedS, with: nil),
			selectedImage: nil
		)
		item.imageInsets = imageInsets
		return item
	}
}
