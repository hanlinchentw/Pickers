//
//  BottomSheetPresenter.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/26.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

class BottomSheetViewModel {
  @Inject var coreService: SelectedCoreService

  var list: List?
  @Published var restaurants: Array<Restaurant> = []
  @Published var listState: BottomSheetViewModel.ListState = .temp
  @Published var isRefresh: Bool = false

  func refresh() {
    if let selectedRestaurants = try? SelectedRestaurant.allIn(CoreDataManager.sharedInstance.managedObjectContext) as? Array<SelectedRestaurant> {
      self.restaurants = selectedRestaurants.map { $0.restaurant }
    }
    isRefresh = true
  }

  func didTapActionButton(_ target: Restaurant) {
    let restaurant = restaurants.first(where: { $0.id == target.id })
    guard let restaurant = restaurant else {
      return
    }
    if restaurant.isSelected {
      try? coreService.deleteRestaurant(id: restaurant.id, in: CoreDataManager.sharedInstance.managedObjectContext)
      restaurant.isSelected.toggle()
    } else {
      try? coreService.addRestaurant(data: ["restaurant": restaurant], in: CoreDataManager.sharedInstance.managedObjectContext)
    }
    listState = listState == .temp ? .temp : .edited
  }

  func createList(name: String) {
    let moc = CoreDataManager.sharedInstance.managedObjectContext
    let uuid = UUID().uuidString
    let date = "\(Date.timeIntervalSinceReferenceDate)"
    let list = List.init(id: uuid, date: date, name: name, context: moc)
    let set = NSSet(array: self.restaurants.filter({ $0.isSelected }))
    list.restaurants = set
    try? moc.save()
    listState = .existed
    self.list = list
  }
}

// MARK: - ListState
extension BottomSheetViewModel {
  enum ListState: Int {
    case temp
    case existed
    case edited
  }
}
