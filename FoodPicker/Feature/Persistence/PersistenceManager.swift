//
//  PersistenceManager.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/30.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation

protocol PersistenceManager {
	func objects<T, S>(_ type: T.Type, predicate: NSPredicate?) -> S?
	func object<T>(_ type: T.Type, key: Any) -> T?
	func add<T>(_ data: [T], update: Bool)
	func add<T>(_ data: T, update: Bool)
	func delete<T>(_ data: [T])
	func delete<T>(_ data: T)
}
