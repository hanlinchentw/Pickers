//
//  ExplorePresenter.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/8/27.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import Foundation

protocol ExploreView: AnyObject {
	func didChangePlaceStatus()
	func didFetchPlace()
}

protocol ExplorePresenting {
	func onViewDidLoad()
	func didSelectPlace(viewModel: PlaceViewModel)
	func count() -> Int
	func viewModel(index: Int) -> PlaceViewModel
}

final class ExplorePresenter: ExplorePresenting {
	var viewModels: [PlaceViewModel] = []
	var placeRepository: PlaceRepositoryProtocol
	var placeSelectionRepository: any PlaceSelectionRepositoryProtocol

	init(placeRepository: PlaceRepositoryProtocol, placeSelectionRepository: any PlaceSelectionRepositoryProtocol) {
		self.placeRepository = placeRepository
		self.placeSelectionRepository = placeSelectionRepository
	}

	func onViewDidLoad() {
		placeRepository.fetch { results, imageUrls in
			DispatchQueue.main.async {
				self.viewModels =  PlaceViewModelFactory.placeViewModel(from: results, andImageUrls: imageUrls)
				self.exploreView?.didFetchPlace()
			}
		}
	}

	func didSelectPlace(viewModel: PlaceViewModel) {
		if placeSelectionRepository.isSelected(id: viewModel.id) {
			placeSelectionRepository.removePlace(with: viewModel)
		} else {
			placeSelectionRepository.addPlace(with: viewModel)
		}
		exploreView?.didChangePlaceStatus()
	}

	func count() -> Int {
		viewModels.count
	}
	
	func viewModel(index: Int) -> PlaceViewModel {
		viewModels[index].isSelected = placeSelectionRepository.isSelected(id: viewModels[index].id)
		return viewModels[index]
	}

	weak var exploreView: ExploreView?
}
