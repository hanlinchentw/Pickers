//
//  ListCardViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/29.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

class ListCardViewModel: ObservableObject {
  var list: List

  init(list: List) {
    self.list = list
  }

  var name: String {
    return list.name
  }

  var date: String {
    let timestamp = Double(list.date) ?? 0.0
    return DateUtils.formateDateFromTimestamp(timestamp, withFormat: .simple)
  }

  var numOfRestaurants: Int {
    return list.restaurants.count ?? 0
  }

  var numOfRestaurantsDisplayText: String {
    return "\(numOfRestaurants) restaurants"
  }

  func getRestaurantByIndex(_ index: Int) -> RestaurantViewObject {
    let restaurant = list.restaurants.allObjects[index] as! Restaurant
    return RestaurantViewObject(restaurant: restaurant)
  }
}
