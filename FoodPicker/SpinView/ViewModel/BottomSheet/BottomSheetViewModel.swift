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

class BottomSheetViewModel: Selectable {
	let moc = CoreDataManager.sharedInstance.managedObjectContext
	@Inject var selectService: SelectedCoreService
	
	var list: List?
	var restaurants: Array<RestaurantViewObject> = []
	
	@Published var listState: BottomSheetViewModel.ListState = .temp
	@Published var isRefresh: Bool = false
	@Published var error: EditListError? = nil
	private var set = Set<AnyCancellable>()
	
	var hasNoRestaurantSelected: Bool { !restaurants.contains(where: { $0.isSelected }) }
	
	func refresh() {
		// 給第一次進入轉盤頁用
		if listState == .temp {
			if let allSelected = try? SelectedRestaurant.allIn(moc) as? Array<SelectedRestaurant> {
				let viewObjects = allSelected.map { RestaurantViewObject(restaurant: $0.restaurant) }
				self.restaurants = viewObjects
			}
		}
		isRefresh = true
	}

	func observeSelectedRestaurantChange() {
		NotificationCenter.default.publisher(for: Notification.Name.NSManagedObjectContextObjectsDidChange)
			.sink { notification in
				guard let userInfo = notification.userInfo else { return }

				let insert = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>
				let delete = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>

				if let insert = insert, let object = insert.first(where: { $0 is SelectedRestaurant}) as? SelectedRestaurant {
					if let index = self.restaurants.firstIndex(where: { $0.id == object.id }) {
						self.restaurants[index].isSelected = true
					} else {
						self.restaurants.append(RestaurantViewObject(restaurant: object.restaurant))
					}
				}
				if let delete = delete, let object = delete.first(where: { $0 is SelectedRestaurant}) as? SelectedRestaurant {
					if let index = self.restaurants.firstIndex(where: { $0.id == object.id }) {
						self.restaurants[index].isSelected  = false
					}
				}

				self.listState = self.listState == .temp ? .temp : .edited
				self.isRefresh = true
			}
			.store(in: &set)
	}
	
	func didTapSelectButton(_ target: RestaurantViewObject, at indexPath: IndexPath) {
		selectRestaurant(isSelected: target.isSelected, restaurant: target)
	}
	
	func createList(name: String) {
		let moc = CoreDataManager.sharedInstance.managedObjectContext
		let uuid = UUID().uuidString
		let date = "\(Date.timeIntervalSinceReferenceDate)"
		let list = List.init(id: uuid, date: date, name: name, context: moc)
		let filterRestaurant = self.restaurants.filter({ $0.isSelected })
		restaurants = filterRestaurant
		
		let restaurantManagedObjectArray = filterRestaurant.map { Restaurant(restaurant: $0) }
		let set = NSSet(array: restaurantManagedObjectArray)
		list.restaurants = set
		try? moc.save()
		
		self.list = list
		listState = .existed
		isRefresh = true
	}
	
	func updateList() {
		let currentSelectedRestaurants = restaurants.filter { $0.isSelected }
		restaurants = currentSelectedRestaurants
		
		let restaurantManagedObjectArray = currentSelectedRestaurants.map { Restaurant(restaurant: $0) }
		list?.restaurants = NSSet(array: restaurantManagedObjectArray)
		try? moc.save()
		
		listState = .existed
		isRefresh = true
	}
	
	func applyList(_ list: List) {
		guard let restaurantsSet = list.restaurants as? Set<Restaurant> else {
			return
		}
		self.restaurants = Array(restaurantsSet.map { RestaurantViewObject(restaurant: $0) })
		self.list = list
		self.listState = .existed
		isRefresh = true
	}
	
	func reset() {
		self.list = nil
		self.listState = .temp
		self.restaurants = []
		isRefresh = true
	}
	
	func deleteList() {
		self.list?.delete(in: moc)
		try? moc.save()
		reset()
	}
}