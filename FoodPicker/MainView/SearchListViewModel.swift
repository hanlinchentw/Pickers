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
	case submit
	
}

class SearchListViewModel: ObservableObject {
	static let DEBOUNCE_MILLISECOND = 500

	@Inject var locationService: LocationService
	@Published var isSearching = false
	@Published var searchState: SearchState = .idle
	@Published var searchText: String = ""
	@Published var viewObjects: Array<RestaurantViewObject> = []
	
	var set = Set<AnyCancellable>()
	
	var shouldSearchResultShow: Bool {
		viewObjects.count > 0
	}
	
	let searchTaskHolder = DataTaskHolder()

	init() {
		bindSearchText()
	}
}
// MARK: - TextField Event
extension SearchListViewModel {
	var onEditing: (_ isEditing: Bool) -> Void {
		{ isEditing in
			self.searchState = isEditing ? .searching : .idle
		}
	}
	
	var onSubmit: VoidClosure {
		{ self.searchState = .submit }
	}
	
	var onClear: VoidClosure {
		{
			self.searchText = ""
			self.isSearching = false
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
			.filter { !$0.isEmpty }
			.sink { text in
				print("serachFor >>> \(text)")
				Task {
					await self.searchFor(text: text)
				}
			}
			.store(in: &set)
	}
	
	func searchFor(text: String) async {
		OperationQueue.main.addOperation { self.isSearching = true }
		searchTaskHolder.cancel()
		do {
			let query = try BusinessService.Query(searchText: text, lat: locationService.getLatitude(), lon: locationService.getLongitude())
			let task: DataTask<Root> = try BusinessService.createSearchDataTask(query: query)
			searchTaskHolder.task = task
			let response = await task.response
			switch response.result {
			case .success(let root):
				OperationQueue.main.addOperation {
					self.viewObjects = root.businesses.map { RestaurantViewObject.init(business: $0) }
					self.isSearching = false
					print("viewObjects >>> \(self.viewObjects)")
				}
			case .failure(let error):
				throw error
			}
		} catch {
			print("MainListViewModel.\(#function), error=\(error.localizedDescription)")
		}
	}
}
