//
//  RestaurantSelectionStore.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/7/21.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation

class PlacesSelectionStore: ObservableObject {
	@Published var status: PlaceSelectionStatus = .draft([]) {
		didSet {
			print(status)
		}
	}

	var selectedPlaces: [PlaceViewModel] {
		switch status {
		case .draft(let array):
			return array
		case .active(let viewModel, _):
			return viewModel.items
		}
	}

	var activePocket: PlacePocketViewModel? {
		if case .active(let viewModel, _) = status {
			return viewModel
		}
		return nil
	}
}
