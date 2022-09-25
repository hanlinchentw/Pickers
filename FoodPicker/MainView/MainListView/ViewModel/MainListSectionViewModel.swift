//
//  MainListViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/21.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import SwiftUI

enum MainListSection: Int, CaseIterable {
	case popular = 0
	case nearby
	
	var description: String {
		switch self {
		case .popular: return "Popular"
		case .nearby: return "Restaurant nearby"
		}
	}
	
	var searchOption: SearchOption {
		switch self {
		case .popular: return .popular
		case .nearby: return .nearyby
		}
	}
	
	var count: Int {
		switch self {
		case .nearby: return 30
		default: return 10
		}
	}
}

class MainListSectionViewModel: ObservableObject, Selectable, Likable {
	@Inject var locationService: LocationService
	@Inject var selectService: SelectedCoreService
	@Inject var likeService: LikedCoreService
	
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
	
	let section: MainListSection
	
	init(section: MainListSection) {
		self.section = section
	}
	
	func fetchData() async throws {
		let query = try BusinessService.Query.init(lat: locationService.getLatitude(), lon: locationService.getLongitude(), option: section.searchOption, limit: section.count, offset: 0)
		let result = try await BusinessService.fetchBusinesses(query: query)
		OperationQueue.main.addOperation {
			self.viewObjects = result.map { RestaurantViewObject.init(business: $0) }
		}
	}
	
	@MainActor
	func refresh() {
		if loadingState == .loaded { return }
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
