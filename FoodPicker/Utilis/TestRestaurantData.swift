//
//  TestRestaurantData.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/14.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import CoreLocation

final class TestRestaurantData {
  static let TEST_BUSINESS = Business(id: "1", name: "Louisa", rating: 4.8, price: "$", imageUrl: Constants.defaultImageURL, distance: 200, isClosed: false, categories: [Categories.init(title: "Cafe")], reviewCount: 15, coordinates: CLLocationCoordinate2D(latitude: 25, longitude: 121))

  static let TEST_RESTAURANT_1 = Restaurant(business: TEST_BUSINESS)

  static let TEST_RESTAURANT_2 = Restaurant(business: TEST_BUSINESS)

  static let TEST_LIKED_RESTAURANT = LikedRestaurant(restaurant: TestRestaurantData.TEST_RESTAURANT_1)

}
