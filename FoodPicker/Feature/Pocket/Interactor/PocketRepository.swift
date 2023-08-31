//
//  PocketRepository.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/31.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation
import RealmSwift

protocol PocketRepositoryProtocol: AnyObject {
	func savePocket(with model: PlacePocketViewModel)
	func deletePocket(with model: PlacePocketViewModel)
}

final class PocketRepository: PocketRepositoryProtocol {
	let entity: RealmPersistenceManagerProtocol

	init(entity: RealmPersistenceManagerProtocol) {
		self.entity = entity
	}
	
	func savePocket(with model: PlacePocketViewModel) {
		let rlmPlaces = RLMPlaceFactory().rlmPlaces(with: model)

		if let object = entity.object(RLM_PlacePocket.self, key: model.id) {
			entity.runTransaction {
				object.items = RealmListBuilder(sequence: rlmPlaces).build()
			}
		} else {
			let pocket = RLM_PlacePocket(id: UUID().uuidString, name: model.name)
			pocket.items.append(objectsIn: rlmPlaces)
			entity.add([pocket], update: true)
		}
	}

	func deletePocket(with model: PlacePocketViewModel) {
		guard let object = entity.object(RLM_PlacePocket.self, key: model.id) else {
			return
		}
		entity.delete([object])
	}
}
