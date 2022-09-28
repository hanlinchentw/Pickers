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

enum SearchState: Int {
	case idle = 0
	case searching
	case done
	case error
}

class SearchListViewModel: ObservableObject {
	static let DEBOUNCE_MILLISECOND = 500
	
	@Inject var locationService: LocationService
	@Published var searchState: SearchState = .idle
	@Published var searchText: String = ""
	@Published var viewObjects: Array<RestaurantViewObject> = []
	var set = Set<AnyCancellable>()
	
	let searchTaskHolder = DataTaskHolder()
	
	init() {
		bindSearchText()
	}
	
	var showSearchResult: Bool {
		if searchText.isEmpty { return false }

		switch searchState {
		case .idle:
			return false
		default:
			return true
		}
	}
}
// MARK: - Auto Search
extension SearchListViewModel {
	class DataTaskHolder: @unchecked Sendable {
		var task: DataTask<Root>?
		func cancel() {
			print("DataTaskHolder.cancel")
			task?.cancel()
		}
	}
	
	func bindSearchText() {
		$searchText
			.debounce(for: .milliseconds(Self.DEBOUNCE_MILLISECOND), scheduler: RunLoop.main)
			.removeDuplicates()
			.filter { !$0.isEmpty }
			.sink { text in
				self.viewObjects = []
				self.searchState = .searching
				Task {
					await self.searchFor(text: text, offset: 0)
					await self.searchFor(text: text, offset: 50)
				}
			}
			.store(in: &set)
	}
	
	func searchFor(text: String, offset: Int = 0) async {
		searchTaskHolder.cancel() // cancel current task
		do {
			let query = try BusinessService.Query(searchText: text, lat: locationService.getLatitude(), lon: locationService.getLongitude(), offset: offset)
			let task: DataTask<Root> = try BusinessService.createSearchDataTask(query: query)
			searchTaskHolder.task = task

			try await Task.sleep(seconds: 1)
			let response = await task.response
			OperationQueue.main.addOperation {
				switch response.result {
				case .success(let root):
					self.viewObjects += root.businesses.map { RestaurantViewObject.init(business: $0) }
					if self.viewObjects.isEmpty {
						self.searchState = .error
					} else {
						self.searchState = .done
					}
				case .failure(_):
					self.searchState = .error
				}
			}
		} catch {
			self.searchState = .error
			print("MainListViewModel.\(#function), error=\(error.localizedDescription)")
		}
	}
}
