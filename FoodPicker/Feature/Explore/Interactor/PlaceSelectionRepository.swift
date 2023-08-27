//
//  PlaceSelectionRepository.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/27.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation

protocol PlaceSelectionRepositoryProtocol {
	func didChangeSelectionStatus(with model: PlaceSelectionDomainModel)
	func isSelected(id: String) -> Bool
}

final class PlaceSelectionRepository: PlaceSelectionRepositoryProtocol {
	var selectionStore: PlacesSelectionStore

	init(selectionStore: PlacesSelectionStore) {
		self.selectionStore = selectionStore
	}

	func didChangeSelectionStatus(with model: PlaceSelectionDomainModel) {
		let firstIndex = selectionStore.selectedPlaces.firstIndex(where: { $0.id == model.id })
		if let firstIndex {
			selectionStore.selectedPlaces.remove(at: firstIndex)
		} else {
			selectionStore.selectedPlaces.append(PlaceSelectionDomainModel(id: model.id, name: model.name))
		}
	}
	
	func isSelected(id: String) -> Bool {
		selectionStore.selectedPlaces.contains(where: { $0.id == id })
	}
}
