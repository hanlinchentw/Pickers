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
  var priceString : NSAttributedString? {
      let attributedTitle =  NSMutableAttributedString(string: "\(restaurant.price)・\(restaurant.businessCategory)・\(distance) m", attributes:
          [NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 14),
           NSAttributedString.Key.foregroundColor:UIColor.gray ])
      return attributedTitle
  }

  var selectButtonImagename : String {
    return "addL"
//      return restaurant.isSelected  ? "icnOvalSelected" :  "addL"
  }

  var likeButtonImagename : String {
    return "icnHeart"
//      return restaurant.isLiked ? "btnBookmarkHeartPressed" : "icnHeart"
  }

  var businessString : NSAttributedString? {

      let closedText =  NSMutableAttributedString(string: "CLOSED", attributes:
      [NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 14),
       NSAttributedString.Key.foregroundColor:UIColor.systemRed])
      let openText =  NSMutableAttributedString(string: "OPEN", attributes:
      [NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 14),
       NSAttributedString.Key.foregroundColor:UIColor.freshGreen])

      return restaurant.isClosed ?? true ? closedText : openText
  }

  var ratedString : NSAttributedString? {
      let attributedTitle =  NSMutableAttributedString(string: "★ ", attributes:
          [NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 14),
           NSAttributedString.Key.foregroundColor:UIColor.butterscotch])
      attributedTitle.append(NSAttributedString(string: "\(restaurant.rating)", attributes:
      [NSAttributedString.Key.foregroundColor : UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1),
       NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 14), ]))
      attributedTitle.append(NSAttributedString(string: " (\(restaurant.reviewCount))", attributes:
          [NSAttributedString.Key.foregroundColor : UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1),
           NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 14), ]))


      return attributedTitle
  }

  var distance : Int {
      let location = CLLocation(latitude: restaurant.coordinates.latitude,
                                longitude: restaurant.coordinates.longitude)
      guard let currentLocation = LocationService.shared.locationManager.location else { return 1000 }
      let distance = location.distance(from: currentLocation)
      return Int(distance)
  }

  init(restaurant : RestaurantViewObject) {
      self.restaurant = restaurant
  }
}
