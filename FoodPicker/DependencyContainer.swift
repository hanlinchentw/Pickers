//
//  DependencyContainer.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/27.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation
import Swinject

final class DependencyContainer {
	static let shared = DependencyContainer()
	
	internal let container = Container()

	init() {
		registerAllComponents()
	}
	
	func registerAllComponents() {
		container.register(LocationManagerProtocol.self) { _ in
			LocationManager.shared
		}
		
		container.register(PlacesSelectionStore.self) { _ in
			PlacesSelectionStore()
		}

		registerPlaceRepository()
		registerPlaceSelectionRepository()
	}
	
	func getService<T>() -> T {
		guard let unwrapService = container.resolve(T.self) else {
			fatalError("Service not found: \(T.self)")
		}
		return unwrapService
	}

	func getService<Service, Arg>(argument: Arg) -> Service {
		guard let service = container.resolve(Service.self, argument: argument) else {
			fatalError("Cannot resolve service of type \(Service.self)")
		}
		return service
	}
}
