//
//  HomeTabItem.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/3/31.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import SwiftUI

enum HomeTabItem: Int, CaseIterable {
	case Recommend
	case Lottery
	case Favorite
	
	var unselectedImage: Image {
		switch self {
		case .Recommend:
			return Image(R.image.homeUnselectedS.name)
		case .Lottery:
			return Image(R.image.spinActive.name)
		case .Favorite:
			return Image(R.image.favoriteUnselectedS.name)
		}
	}
	
	var selectedImage: Image {
		switch self {
		case .Recommend:
			return Image(R.image.homeSelectedS.name)
		case .Lottery:
			return Image(R.image.spinActive.name)
		case .Favorite:
			return Image(R.image.icnTabHeartSelected.name)
		}
	}
	
	var iconSize: CGFloat {
		switch self {
		case .Recommend:
			return 28
		case .Lottery:
			return 56
		case .Favorite:
			return 28
		}
	}
}
