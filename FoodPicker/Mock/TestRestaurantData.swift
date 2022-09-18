//
//  TestRestaurantData.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/14.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import CoreLocation

final class MockedRestaurant {
  static let TEST_BUSINESS_1 = Business(id: "1", name: "Louisa", rating: 4.8, price: "$", imageUrl: Constants.defaultImageURL, distance: 200, isClosed: false, categories: [Categories.init(title: "Cafe")], reviewCount: 15, coordinates: CLLocationCoordinate2D(latitude: 25, longitude: 121))
  static let TEST_BUSINESS_2 = Business(id: "2", name: "Starbucks", rating: 5.0, price: "$&", imageUrl: Constants.defaultImageURL, distance: 500, isClosed: false, categories: [Categories.init(title: "Cafe")], reviewCount: 55, coordinates: CLLocationCoordinate2D(latitude: 25.2, longitude: 121))

  static let TEST_RESTAURANT_1 = Restaurant(business: TEST_BUSINESS_1)
  static let TEST_RESTAURANT_2 = Restaurant(business: TEST_BUSINESS_2)

  static let TEST_RESTAURANT_VIEW_OBJECT_1 = RestaurantViewObject(restaurant: TEST_RESTAURANT_1)
  static let TEST_RESTAURANT_VIEW_OBJECT_2 = RestaurantViewObject(restaurant: TEST_RESTAURANT_2)

  static let TEST_RESTAURANT_VIEW_OBJECT_ARRAY = [TEST_RESTAURANT_VIEW_OBJECT_1, TEST_RESTAURANT_VIEW_OBJECT_2, TEST_RESTAURANT_VIEW_OBJECT_1, TEST_RESTAURANT_VIEW_OBJECT_2, TEST_RESTAURANT_VIEW_OBJECT_1, TEST_RESTAURANT_VIEW_OBJECT_2, TEST_RESTAURANT_VIEW_OBJECT_1, TEST_RESTAURANT_VIEW_OBJECT_2]
}
