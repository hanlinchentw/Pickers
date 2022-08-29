//
//  BottomSheetPresenter.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/8/26.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import Combine
import CoreData

class BottomSheetViewModel {
  let moc = CoreDataManager.sharedInstance.managedObjectContext
  @Inject var coreService: SelectedCoreService

  var list: List?
  var restaurants: Array<Restaurant> = []

  @Published var listState: BottomSheetViewModel.ListState = .temp
  @Published var isRefresh: Bool = false

  private var set = Set<AnyCancellable>()

  func refresh() {
    // 給第一次進入轉盤頁用
    if let selectedRestaurants = try? SelectedRestaurant.allIn(CoreDataManager.sharedInstance.managedObjectContext) as? Array<SelectedRestaurant> {
      let allSelectedRestaurants = selectedRestaurants.map { $0.restaurant }
      if listState == .temp {
        self.restaurants = allSelectedRestaurants
      }
    }
    isRefresh = true
  }

  func observeSelectedRestaurantChange() {
    NotificationCenter.default.publisher(for: Notification.Name.NSManagedObjectContextObjectsDidChange)
      .sink { notification in
        guard let userInfo = notification.userInfo else { return }
        let insert = userInfo[NSInsertedObjectsKey] as? Set<SelectedRestaurant>
        let delete = userInfo[NSDeletedObjectsKey] as? Set<SelectedRestaurant>
        if let insert = insert, let object = insert.first {
          if let index = self.restaurants.firstIndex(where: { $0.id == object.id }) {
            self.restaurants[index].isSelected = true
          } else {
            self.restaurants.append(object.restaurant)
          }
        }
        if let delete = delete, let object = delete.first {
          if let index = self.restaurants.firstIndex(where: { $0.id == object.id }) {
            self.restaurants[index].isSelected  = false
          }
        }
        self.listState = self.listState == .temp ? .temp : .edited
      }
      .store(in: &set)
  }

  func didTapActionButton(_ target: Restaurant) {
    let restaurant = restaurants.first(where: { $0.id == target.id })
    guard let restaurant = restaurant else {
      return
    }
    if restaurant.isSelected {
      try? coreService.deleteRestaurant(id: restaurant.id, in: CoreDataManager.sharedInstance.managedObjectContext)
    } else {
      try? coreService.addRestaurant(data: ["restaurants": [restaurant]], in: CoreDataManager.sharedInstance.managedObjectContext)
    }
    listState = listState == .temp ? .temp : .edited
  }

  func createList(name: String) {
    let moc = CoreDataManager.sharedInstance.managedObjectContext
    let uuid = UUID().uuidString
    let date = "\(Date.timeIntervalSinceReferenceDate)"
    let list = List.init(id: uuid, date: date, name: name, context: moc)
    let filterRestaurant = self.restaurants.filter({ $0.isSelected })
    restaurants = filterRestaurant
    let set = NSSet(array: filterRestaurant)
    list.restaurants = set
    try? moc.save()

    self.list = list
    listState = .existed
    isRefresh = true
  }

  func updateList() {
    let currentSelectedRestaurants = restaurants.filter { $0.isSelected }
    restaurants = currentSelectedRestaurants
    list?.restaurants = NSSet(array: restaurants)
    try? moc.save()

    listState = .existed
    isRefresh = true
  }

  func applyList(_ list: List) {
    guard let restaurantsSet = list.restaurants as? Set<Restaurant> else {
      return
    }
    self.restaurants = Array(restaurantsSet)
    self.list = list
    self.listState = .existed
    isRefresh = true
  }
}
// MARK: - Edit list error
extension BottomSheetViewModel {
  enum EditListError: Error {
    case updateEmptyList
    case saveEmptyList
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
// MARK: - UI Properties
extension BottomSheetViewModel {
  var listName: String {
    switch listState {
    case .temp: return "My selected list"
    case .existed: return list!.name
    case .edited:
      let ns = NSMutableAttributedString(string: list!.name, attributes: .attributes([.arial16Bold, .black]))
      ns.append(NSAttributedString(string: " *", attributes: .butterScotch))
      return ns.string
    }
  }

  var saveButtonText: String? {
    switch listState {
    case .temp: return "Save ist"
    case .existed: return nil
    case .edited: return "Save as new"
    }
  }

  var saveButtonHidden: Bool {
    switch listState {
    case .temp: return false
    case .existed: return true
    case .edited: return false
    }
  }

  var updateButtonHidden: Bool {
    switch listState {
    case .temp: return true
    case .existed: return true
    case .edited: return false
    }
  }
}
