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
	func didSelectPlace(viewModel: PlaceListViewModel)
	func count() -> Int
	func viewModel(index: Int) -> PlaceListViewModel
}

final class ExplorePresenter: ExplorePresenting {
	var viewModels: [PlaceListViewModel] = []
	var placeRepository: PlaceRepositoryProtocol
	var placeSelectionRepository: PlaceSelectionRepositoryProtocol

	init(placeRepository: PlaceRepositoryProtocol, placeSelectionRepository: PlaceSelectionRepositoryProtocol) {
		self.placeRepository = placeRepository
		self.placeSelectionRepository = placeSelectionRepository
	}

	func onViewDidLoad() {
		placeRepository.fetch { results, imageUrls in
			DispatchQueue.main.async {
				self.viewModels = zip(results, imageUrls).mapPlaceApiResultToRestaurantViewObject()
				self.exploreView?.didFetchPlace()
			}
		}
	}

	func didSelectPlace(viewModel: PlaceListViewModel) {
		placeSelectionRepository.didChangeSelectionStatus(with: PlaceSelectionDomainModel(id: viewModel.id, name: viewModel.name))
		exploreView?.didChangePlaceStatus()
	}

	func count() -> Int {
		viewModels.count
	}
	
	func viewModel(index: Int) -> PlaceListViewModel {
		viewModels[index].isSelected = placeSelectionRepository.isSelected(id: viewModels[index].id)
		return viewModels[index]
	}

	weak var exploreView: ExploreView?
}
