//
//  PlacesSelectionStore.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/7/21.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation
import Observation

@Observable
final class PlacesSelectionStore {
	static let shared = PlacesSelectionStore()

  var selectedPlaces: [PlaceViewModel] = []

	@discardableResult
	func togglePlace(model: PlaceViewModel) -> Bool {
		if selectedPlaces.contains(model) {
			removePlace(with: model)
		} else {
			addPlace(with: model)
		}
	}

	@discardableResult
	func removePlace(with model: PlaceViewModel) -> Bool {
		if !selectedPlaces.contains(model) { return false }
		selectedPlaces.removeAll(where: { $0 == model })
		return true
  }

	@discardableResult
	func addPlace(with model: PlaceViewModel) -> Bool {
    if selectedPlaces.contains(model) { return false }
    selectedPlaces.append(model)
		return true
  }

  func isSelected(id: String) -> Bool {
    selectedPlaces.contains(where: { $0.id == id })
  }
}
