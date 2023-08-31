//
//  RealmListBuilder.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/31.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmListBuilder<T: RealmCollectionValue> {
	let sequence: [T]
	
	init(sequence: [T]) {
		self.sequence = sequence
	}
	
	func build() -> List<T> {
		let items = List<T>()
		items.append(objectsIn: sequence)
		return items
	}
}
