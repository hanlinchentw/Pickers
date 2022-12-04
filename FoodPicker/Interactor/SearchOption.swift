//
//  SearchOption.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/20.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

enum SearchOption {
	case nearyby
	case popular
	case bestMatch
	case prominence

	var sortBy: String {
		switch self {
		case .nearyby: return "distance"
		case .popular: return "rating"
		case .bestMatch: return "best_match"
		case .prominence: return "prominence"
		}
	}
}
