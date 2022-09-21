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
	@Published var searchState: SearchState = .idle
	@Published var searchText: String = ""
	@Published var searchResult: Array<RestaurantViewObject> = []
	
	var set = Set<AnyCancellable>()
	
	init() {
		bindSearchState()
	}
	
	func search() {
		
	}
}

extension SearchListViewModel {
	func bindSearchState() {
		$searchState
			.sink { text in
				print(">>> onSubmit.text=\(text)")
				
			}
			.store(in: &set)
	}
}
