//
//  SearchListViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/20.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import Combine

enum SearchState {
	case idle
	case searching
	case submit
	
}

class SearchListViewModel: ObservableObject {
	@Inject var locationService: LocationService
	@Published var isSearching = false
	@Published var searchState: SearchState = .idle
	@Published var searchText: String = ""
	@Published var viewObjects: Array<RestaurantViewObject> = []
	
	var set = Set<AnyCancellable>()
	
	var dataCount: Int {
		viewObjects.count
	}
	
	var onEditing: (_ isEditing: Bool) -> Void {
		return { isEditing in
			self.searchState = isEditing ? .searching : .idle
		}
	}
	
	var onSubmit: VoidClosure {
		return {
			self.searchState = .submit
		}
	}
	
	var onClear: VoidClosure {
		return {
			self.searchText = ""
			self.isSearching = false
		}
	}
	
	init() {
		bindSearchState()
	}

	func onSearch() {
		isSearching = true
		do {
			let query = try BusinessService.Query.init(searchText: searchText, lat: locationService.getLatitude(), lon: locationService.getLongitude(), option: .bestMatch, limit: 50, offset: 0)
			Task {
				let result = try await BusinessService.fetchBusinesses(query: query)
				OperationQueue.main.addOperation {
					self.viewObjects = result.map { RestaurantViewObject.init(business: $0) }
				}
			}
		} catch {
			print("MainListViewModel.\(#function), error=\(error.localizedDescription)")
		}
	}
}

extension SearchListViewModel {
	func bindSearchState() {
		$searchState
			.sink { state in
				print("SearchListViewModel.state >>> \(state)")
				if state == .submit { self.onSearch() }
			}
			.store(in: &set)
	}
}
