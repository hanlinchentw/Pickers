//
//  SearchVCSection.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/10/12.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit

extension SearchViewController {
	enum Section: Int, Hashable, CaseIterable {
		case Recommend = 0
		case Search = 1
	}
	
	enum SectionItem: Hashable {
		case Recommend(imageName: String)
		case Search(restaurant: RestaurantViewObject)
		
		var identifier: String {
			switch self {
			case .Recommend(let imageName):
				return imageName
			case .Search(let restaurant):
				return restaurant.id
			}
		}
		
		static var fixedCategories: Array<String> {
			["Pizza", "Bubble Tea", "Coffee", "Chinese", "Hamburger", "Italian", "Japanese", "Korean", "Taiwanese", "Thai"]
		}
		
		static var fixedRecommendSectionItems: [SectionItem] {
			fixedCategories.map {.Recommend(imageName: $0)}
		}
	}
}
