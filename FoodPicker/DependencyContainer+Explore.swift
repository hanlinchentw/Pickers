//
//  DependencyContainer+Explore.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/27.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation
import Swinject

extension DependencyContainer {
	func registerPlaceRepository() {
		container.register(PlaceRepositoryProtocol.self) { _, provider in
			PlaceRepository(placeNerworkProvider: provider)
		}
	}
	
	func registerPlaceSelectionRepository() {
		container.register(PlaceSelectionRepositoryProtocol.self) { resolver, store in
			PlaceSelectionRepository(selectionStore: store)
		}
	}
}
