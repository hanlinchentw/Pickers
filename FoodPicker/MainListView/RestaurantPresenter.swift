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

  var imageUrl: String {
    return restaurant.imageUrl ?? Constants.defaultImageURL
  }

  var thirdRowString: String {
    "\(restaurant.price)・\(restaurant.businessCategory)・\(distance) m"
  }

  var ratingWithOneDecimal: String {
    "\((restaurant.rating * 10).rounded()/10)"
  }

  var openOrCloseString: String {
    return restaurant.isClosed ? "Closed" : "Open"
  }

  var openOrCloseColor: Color {
    return restaurant.isClosed ? .red : .green
  }

  var rating: String {
    return "\(restaurant.rating)"
  }

  var reviewCount: String {
    return "(\(restaurant.reviewCount)+)"
  }

  var distance : Int {
    LocationService.shared.getDistanceFromCurrentLocation(restaurant.latitude, restaurant.longitude)
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
      return "btnBookmarkHeartPressed"
    }
    return isLiked ? "btnBookmarkHeartPressed" : "icnHeart"
  }

  init(restaurant : RestaurantViewObject, actionButtonMode: ActionButtonMode, isLiked: Bool? = nil) {
    self.restaurant = restaurant
    self.actionButtonMode = actionButtonMode
    self.isLiked = isLiked
  }
}
