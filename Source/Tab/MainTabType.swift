//
//  MainTabType.swift
//  Picker
//
//  Created by 陳翰霖 on 2025/8/15.
//

import Foundation

enum MainTabType: Int, CaseIterable, Identifiable {
	case home, picker, favorite

	var id: Int { rawValue }

	var image: String {
		switch self {
		case .home:
			R.image.homeUnselectedS.name
		case .picker:
			R.image.spinActive.name
		case .favorite:
			R.image.favoriteUnselectedS.name
		}
	}

	var selectedImage: String {
		switch self {
		case .home:
			R.image.homeSelectedS.name
		case .picker:
			R.image.spinActive.name
		case .favorite:
			R.image.favoriteUnselectedS.name
		}
	}
}
