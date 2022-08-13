//
//  RestaurantCardPresenter.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/9.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit
import CoreLocation

class RestaurantCardPresenter {
  private let restaurant : RestaurantViewObject

  var name: String {
    return restaurant.name
  }

  var imageUrl: URL {
    return restaurant.imageUrl ?? URL(string: defaultImageURL)!
  }

  var sccondRowString: String {
    return "\(restaurant.price)・\(restaurant.businessCategory)・\(distance) m"
  }

  var selectButtonImagename : String {
    return "addL"
//      return restaurant.isSelected  ? "icnOvalSelected" :  "addL"
  }

  var likeButtonImagename : String {
    return "icnHeart"
//      return restaurant.isLiked ? "btnBookmarkHeartPressed" : "icnHeart"
  }

  var openOrCloseString: String {
    guard let isClosed = restaurant.isClosed else {
      return "Close"
    }
    return isClosed ? "Closed" : "Open"
  }

  var rating: String {
    return "\(restaurant.rating)"
  }

  var reviewCount: String {
    return "+(\(restaurant.reviewCount))"
  }

  var distance : Int {
    return 10
//      let location = CLLocation(latitude: restaurant.coordinates.latitude,
//                                longitude: restaurant.coordinates.longitude)
//      guard let currentLocation = LocationService.shared.locationManager.location else { return 1000 }
//      let distance = location.distance(from: currentLocation)
//      return Int(distance)
  }

  init(restaurant : RestaurantViewObject) {
      self.restaurant = restaurant
  }
}
