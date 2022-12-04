//
//  EditListViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/17.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation

class InvalidListRestaurantsError: Error {}

class EditListViewModel: ObservableObject {
  var list: List? = nil

  @Published var editListName: String = ""
  @Published var viewObjects: Array<RestaurantViewObject> = []
  @Published var alert: EditAlertType? = nil

  var saveButtonDisabled: Bool {
    return editListName.isEmpty
  }

  func setInitialValue(list: List) {
		self.list = list
    editListName = list.name
    try! setRestaurantsViewObjects(list: list)
  }

  func saveList(completion: @escaping () -> Void) {
    if viewObjects.isEmpty {
			alert = .emptyList
      return
    }
		print("saveList.editListName >>> \(editListName)")
    list?.name = editListName
    list?.restaurants = NSSet(array: viewObjects.map {Restaurant(restaurant: $0)})
    try? CoreDataManager.sharedInstance.managedObjectContext.save()
    completion()
  }
}

extension EditListViewModel {
  func setRestaurantsViewObjects(list: List) throws {
    guard let restaurants = Array(list.restaurants) as? Array<Restaurant> else {
      throw InvalidListRestaurantsError()
    }
    self.viewObjects = restaurants.map { RestaurantViewObject.init(restaurant: $0) }
  }
}

extension EditListViewModel {
	enum EditAlertType: Int {
		case emptyList = 0
		case deleteList
	}
}
