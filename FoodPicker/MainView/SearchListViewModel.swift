//
//  SearchListViewModel.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2022/9/20.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import Foundation
import Combine
import Alamofire

enum SearchState {
	case idle
	case searching
	case done(result: Array<RestaurantViewObject>)
	case error(error: Error)
}

enum SearchError: Error {
	case empty
	case network
}
class SearchListViewModel: ObservableObject {
	@Inject var locationService: LocationService
	@Published var searchState: SearchState = .idle
	@Published var viewObjects: Array<RestaurantViewObject> = []
	var set = Set<AnyCancellable>()
	
	func clearResult() {
		searchState = .idle
		viewObjects = []
	}
}
// MARK: - Search
extension SearchListViewModel {
	func searchFor(text: String, offset: Int = 0) {
		searchState = .searching
		Task {
			do {
				guard NetworkMonitor.shared.isConnected else {
					self.searchState = .error(error: SearchError.network)
					return
				}
				let query = try Query(searchText: text, lat: locationService.getLatitude(), lon: locationService.getLongitude(), offset: offset)
				let task: DataTask<Root> = try BusinessService.createSearchDataTask(query: query)
				let response = await task.response
				switch response.result {
				case .success(let root):
					OperationQueue.main.addOperation {
						self.viewObjects = root.businesses.map { RestaurantViewObject.init(business: $0) }
						if self.viewObjects.isEmpty {
							self.searchState = .error(error: SearchError.empty)
							return
						}
						self.searchState = .done(result: self.viewObjects)
					}
				case .failure(let error):
					self.searchState = .error(error: error)
				}
			} catch {
				self.searchState = .error(error: error)
				print("MainListViewModel.\(#function), error=\(error.localizedDescription)")
			}
		}
	}
}
