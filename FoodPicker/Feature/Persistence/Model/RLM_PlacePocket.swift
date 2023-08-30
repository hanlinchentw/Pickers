//
//  RLM_PlacePocket.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/30.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation
import RealmSwift

class RLM_PlacePocket: Object {
	@Persisted(primaryKey: true) var id: String
	@Persisted var name: String
	@Persisted var items: List<RLM_Place>
	
	convenience init(id: String, name: String) {
		self.init()
		self.id = id
		self.name = name
	}
}
