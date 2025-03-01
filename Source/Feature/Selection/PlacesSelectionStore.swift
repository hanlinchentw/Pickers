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
  var selectedPlaces: [PlaceViewModel] = []

  func onClickSelectButton(viewModel: PlaceViewModel) {
    if isSelected(id: viewModel.id) {
      removePlace(with: viewModel)
    } else {
      addPlace(with: viewModel)
    }
  }

  func removePlace(with model: PlaceViewModel) {
    selectedPlaces = selectedPlaces.filter { $0.id == model.id }
  }

  func addPlace(with model: PlaceViewModel) {
    if selectedPlaces.contains(model) { return }
    selectedPlaces.append(model)
  }

  func isSelected(id: String) -> Bool {
    selectedPlaces.contains(where: { $0.id == id })
  }
}
