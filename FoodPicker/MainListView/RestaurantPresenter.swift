//
//  RestaurantCardPresenter.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/9.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import SwiftUI
import CoreLocation

struct RestaurantPresenter {
  private var restaurant: Restaurant
  var isSelected: Bool?
  var isLiked: Bool?

  var name: String {
    return restaurant.name
  }

  var imageUrl: URL {
    return restaurant.imageUrl ?? URL(string: defaultImageURL)!
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
    return "+(\(restaurant.reviewCount))"
  }


  var distance : Int {
    LocationService.shared.getDistanceFromCurrentLocation(restaurant.latitude, restaurant.longitude)
  }

  var selectButtonImage: String {
    guard let isSelected = isSelected else {
      return "icnOvalSelected"
    }

    return isSelected ? "icnOvalSelected" : "addL"
  }

  var likeButtonImage: String {
    guard let isLiked = isLiked else {
      return "btnBookmarkHeartPressed"
    }

    return isLiked ? "btnBookmarkHeartPressed" : "icnHeart"
  }

  init(restaurant : Restaurant, isSelected: Bool? = nil, isLiked: Bool? = nil) {
    self.restaurant = restaurant
    self.isSelected = isSelected
    self.isLiked = isLiked
  }
}
