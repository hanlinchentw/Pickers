//
//  LuckyWheelViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2020/7/15.
//  Copyright © 2020 陳翰霖. All rights reserved.
//

import UIKit
import Combine
import CoreData

class SpinWheelPresenter  {
  @Inject var selectedCoreService: SelectedCoreService

  @Published var restaurants: Array<RestaurantViewObject> = []
  @Published var isRefresh: Bool = false

  private var set = Set<AnyCancellable>()

  init() {
    observeSelectedRestaurantChange()
  }

  var numOfSection: Int {
    if restaurants.isEmpty { return 4 }
    return restaurants.count * 2
  }

  var isSpinButtonEnabled: Bool {
    !restaurants.isEmpty
  }

  var itemForSection : [WheelItem] {
    if restaurants.isEmpty { return Self.defaultItems }

    var items1 = [WheelItem]()
    var items2 = [WheelItem]()

    if restaurants.count % 2 == 0 {
      for (index, item) in restaurants.enumerated(){
        let itemColor : UIColor = index % 2 != 0 ? .white : .pale
        let wheelItem1 = WheelItem(title: item.name, titleColor: .customblack, itemColor: itemColor)
        items1.append(wheelItem1)
        items2 = items1
      }
    } else {
      for (index, item) in self.restaurants.enumerated(){
        let itemColor : UIColor = index % 2 != 0 ? .white : .pale
        let oppsiteColor : UIColor = itemColor == .white ? .pale : .white
        let wheelItem1 = WheelItem(title: item.name, titleColor: .customblack, itemColor: itemColor)
        let wheelItem2 = WheelItem(title: item.name, titleColor: .customblack, itemColor: oppsiteColor)
        items1.append(wheelItem1)
        items2.append(wheelItem2)
      }
    }
    return items1 + items2
  }

  func observeSelectedRestaurantChange() {
    NotificationCenter.default.publisher(for: Notification.Name.NSManagedObjectContextObjectsDidChange)
      .sink { notification in
        self.refresh()
      }
      .store(in: &set)
  }

  func refresh() {
    if let selectedRestaurants = try? SelectedRestaurant.allIn(CoreDataManager.sharedInstance.managedObjectContext) as? Array<SelectedRestaurant> {
      self.restaurants = selectedRestaurants.map { RestaurantViewObject(restaurant: $0.restaurant) }
    }
    isRefresh = true
  }

  func applyList(_ list: List) {
    let moc = CoreDataManager.sharedInstance.managedObjectContext
    reset()
    for restaurant in list.restaurants.allObjects {
      try? selectedCoreService.addRestaurant(data: ["restaurant": restaurant], in: moc)
    }
    try? moc.save()
  }

  func reset() {
    let moc = CoreDataManager.sharedInstance.managedObjectContext
    try? SelectedRestaurant.deleteAll(in: moc)
    try? moc.save()
  }
}

extension SpinWheelPresenter {
  static let item1 = WheelItem(title: "Picker!", titleColor: .customblack, itemColor: .white)
  static let item2 = WheelItem(title: "Picker!", titleColor: .customblack, itemColor: .pale)
  static let item3 = WheelItem(title: "Picker!", titleColor: .customblack, itemColor: .white)
  static let item4 = WheelItem(title: "Picker!", titleColor: .customblack, itemColor: .pale)
  static let defaultItems = [item1, item2, item3, item4]
}
