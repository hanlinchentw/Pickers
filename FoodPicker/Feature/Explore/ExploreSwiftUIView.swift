//
//  ExplorerView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/6/7.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import SwiftUI

struct ExploreSwiftUIView: UIViewControllerRepresentable {
	typealias UIViewControllerType = ExploreMainViewController

	@ObservedObject var selectionStore: PlacesSelectionStore

	func makeUIViewController(context: Context) -> ExploreMainViewController {
		let presenter = ExplorePresenter(
			placeRepository: DependencyContainer.shared.getService(argument: NearbySearchProviderImpl()),
			placeSelectionRepository: DependencyContainer.shared.getService(argument: selectionStore)
		)
		let viewController = ExploreMainViewController(presenter: presenter)
		presenter.exploreView = viewController
		return viewController
	}
	
	func updateUIViewController(_ uiViewController: ExploreMainViewController, context: Context) {
		uiViewController.refreshView()
	}
}
