//
//  NSManagedObjectContextObjectsDidChange.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/10/2.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import CoreData

protocol RestaurantContextDidChangeNotify {
	var contextObjectDidChange: ((Notification) -> Void)? { get }
	var selectContextDidInsert: ((_ insert: SelectedRestaurant) -> Void)? { get }
	var selectContextDidDelete: ((_ delete: SelectedRestaurant) -> Void)? { get }
	var likeContextDidInsert: ((_ insert: LikedRestaurant) -> Void)? { get }
	var likeContextDidDelete: ((_ delete: LikedRestaurant) -> Void)? { get }

	func observeContextObjectsChange()
}

extension RestaurantContextDidChangeNotify {
	var contextObjectDidChange: ((Notification) -> Void)? { nil }
	var selectContextDidInsert: ((_ insert: SelectedRestaurant) -> Void)? { nil }
	var selectContextDidDelete: ((_ delete: SelectedRestaurant) -> Void)? { nil }
	var likeContextDidInsert: ((_ insert: LikedRestaurant) -> Void)? { nil }
	var likeContextDidDelete: ((_ delete: LikedRestaurant) -> Void)? { nil }
}

extension RestaurantContextDidChangeNotify {
	func observeContextObjectsChange() {
		NotificationCenter.default.addObserver(
			forName: Notification.Name.NSManagedObjectContextObjectsDidChange,
			object: nil,
			queue: .main,
			using: { notification in
				guard let userInfo = notification.userInfo else { return }

				let insert = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>
				let delete = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>

				self.contextObjectDidChange?(notification)
				if let insert = insert {
					if let object = insert.first(where: { $0 is SelectedRestaurant}) as? SelectedRestaurant {
						self.selectContextDidInsert?(object)
					}
					if let object = insert.first(where: { $0 is LikedRestaurant}) as? LikedRestaurant {
						self.likeContextDidInsert?(object)
					}
				}

				if let delete = delete {
					if let object = delete.first(where: { $0 is SelectedRestaurant}) as? SelectedRestaurant {
						self.selectContextDidDelete?(object)
					}
					if let object = delete.first(where: { $0 is LikedRestaurant}) as? LikedRestaurant {
						self.likeContextDidDelete?(object)
					}
				}

			}
		)
	}
}
