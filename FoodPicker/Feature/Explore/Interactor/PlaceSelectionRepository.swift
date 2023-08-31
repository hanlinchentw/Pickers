//
//  PlaceSelectionRepository.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/27.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation

protocol PlaceSelectionRepositoryProtocol: AnyObject {
	func isSelected(id: String) -> Bool
	func removePlace(with model: PlaceViewModel)
	func addPlace(with model: PlaceViewModel)
}

final class PlaceSelectionRepository: PlaceSelectionRepositoryProtocol {
	var selectionStore: PlacesSelectionStore

	init(selectionStore: PlacesSelectionStore) {
		self.selectionStore = selectionStore
	}

	func removePlace(with model: PlaceViewModel) {
		switch selectionStore.status {
		case .draft(let places):
			selectionStore.status = .draft(places.filter({ $0 != model }))
		case .active(var viewModel, let original):
			viewModel.items = viewModel.items.filter({ $0 != model })
			selectionStore.status = .active(viewModel, original: original)
		}
	}

	func addPlace(with model: PlaceViewModel) {
		switch selectionStore.status {
		case .draft(let places):
			selectionStore.status = .draft(places + [model])
		case .active(var viewModel, let original):
			viewModel.items = viewModel.items + [model]
			selectionStore.status = .active(viewModel, original: original)
		}
	}

	func isSelected(id: String) -> Bool {
		selectionStore.selectedPlaces.contains(where: { $0.id == id })
	}
}
