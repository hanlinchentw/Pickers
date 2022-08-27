//
//  BottomSheetPresenter.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/26.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

class BottomSheetPresenter  {
  @Published var list: List?
  @Published var restaurants: Array<Restaurant> = []
  @Published var isRefresh: Bool = false

  func refresh() {
    if let selectedRestaurants = try? SelectedRestaurant.allIn(CoreDataManager.sharedInstance.managedObjectContext) as? Array<SelectedRestaurant> {
      self.restaurants = selectedRestaurants.map { $0.restaurant }
    }
    isRefresh = true
  }
}
