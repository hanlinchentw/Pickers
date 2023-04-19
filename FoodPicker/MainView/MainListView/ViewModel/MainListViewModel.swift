//
//  MainListViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/21.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

protocol MainListViewModelProtocol: ObservableObject {
	var viewObjects: Array<RestaurantViewObject> { get set }
	var loadingState: LoadingState { get set }
	
	var dataCount: Int { get }
	
	func fetchData() async throws
	func refresh()
}

class MainListViewModel: MainListViewModelProtocol {
	@Inject var locationManager: LocationManagerProtocol
	
	@Published var loadingState: LoadingState = .loading
	@Published var viewObjects: Array<RestaurantViewObject> = []
	
	var dataCount: Int {
		if self.loadingState == .loaded {
			return self.viewObjects.count
		}
		if self.loadingState == .loading {
			return 10 // Skeleton view
		}
		return 0
	}

	init() {
		bindLocation()
	}
	
	var set = Set<AnyCancellable>()
	
	func bindLocation() {
		locationManager.locationPublisher.sink { location in
			guard location != nil, self.viewObjects.isEmpty else {
				return
			}
			Task {
				try? await self.fetchData()
			}
		}
		.store(in: &set)
	}
	
	func fetchData() async throws {
		guard let currentLocation = locationManager.lastLocation else {
			return
		}
		
		let query = Query.init(lat: currentLocation.latitude, lon: currentLocation.longitude, option: .bestMatch, limit: 20, offset: 0)
		let result = try await BusinessService.fetchBusinesses(query: query)
		OperationQueue.main.addOperation {
			self.viewObjects = result.map { RestaurantViewObject.init(business: $0) }
		}
	}

	func refresh() {
		Task {
			loadingState = .loading
			if let _ = try? await fetchData() {
				loadingState = viewObjects.isEmpty ? .error : .loaded
			} else {
				loadingState = .error
			}
		}
	}
}
