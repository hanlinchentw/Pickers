//
//  RestaurantCardPresenter.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/9.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI
import CoreLocation

enum ActionButtonMode {
	case none
	case edit
	case select
	case deselect
}

struct RestaurantPresenter {
	private(set) var restaurant: RestaurantViewObject
	var actionButtonMode: ActionButtonMode = .none
	var isLiked: Bool?
	var isEditing: Bool?
	
	var name: String {
		return restaurant.name
	}
	
	var imageUrl: String? {
		restaurant.imageUrl
	}
	
	var priceCategoryDistanceText: String? {
		var text = ""
		if let price = restaurant.price {
			text.append(price)
		}
		if let category = restaurant.businessCategory {
			if !text.isEmpty { text.append("・") }
			text.append("\(category)")
		}
		if let distance = distanceFromCurrentLocation {
			if !text.isEmpty { text.append("・") }
			text.append("\(distance) m")
		}
		return text.isEmpty ? nil : text
	}
	
	var openOrCloseString: String {
		return restaurant.isClosed ? "Closed" : "Open"
	}
	
	var openOrCloseColor: Color {
		return restaurant.isClosed ? .red : .green
	}

	var ratingWithOneDecimal: String? {
		guard let rating = restaurant.rating, rating != 0, !rating.isNaN else {
			return nil
		}
		return "\((rating * 10).rounded()/10)"
	}
	
	var reviewCount: String? {
		guard let reviewCount = restaurant.reviewCount else {
			return nil
		}
		return "(\(reviewCount)+)"
	}
	
	var distanceFromCurrentLocation : Int? {
		guard let lat = restaurant.latitude, let lon = restaurant.longitude,
						lat != 0, lon != 0 else {
			return nil
		}
		return LocationService.shared.distanceFromCurrent(lat, lon)
	}
	
	var actionButtonImage: String {
		switch actionButtonMode {
		case .none: return ""
		case .select: return "icnOvalSelected"
		case .deselect: return "addL"
		case .edit: return "icnDeleteNoShadow"
		}
	}
	
	var likeButtonImage: String {
		guard let isLiked = isLiked else {
			return "btnBookmarkHeartDefault"
		}
		return isLiked ? "btnBookmarkHeartPressed" : "btnBookmarkHeartDefault"
	}
	
	var ratingAndReviewCountString: NSMutableAttributedString? {
		guard let rating = restaurant.rating, let reviewCount = restaurant.reviewCount,
					rating != 0, !rating.isNaN else {
			return nil
		}

		let attributedString = NSMutableAttributedString(string: "★", attributes: .attributes([.systemYellow, .arial12]))
		attributedString.append(NSAttributedString(string: " \(rating)", attributes: .attributes([.black, .arial12])))
		attributedString.append(NSAttributedString(string: " \(reviewCount)", attributes: .attributes([.lightGray, .arial12])))
		
		let paragraph = NSMutableParagraphStyle()
		paragraph.lineSpacing = 2
		attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraph, range: NSRange(0 ..< attributedString.length))
		return attributedString
	}
	
	init(restaurant : RestaurantViewObject, actionButtonMode: ActionButtonMode, isLiked: Bool? = nil) {
		self.restaurant = restaurant
		self.actionButtonMode = actionButtonMode
		self.isLiked = isLiked
	}
}
