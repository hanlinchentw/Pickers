//
//  ExplorerView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/6/7.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import SwiftUI

struct ExplorerView: UIViewControllerRepresentable {
	typealias UIViewControllerType = ExploreMainViewController

	@ObservedObject var selectionStore: RestaurantSelectionStore

	func makeUIViewController(context: Context) -> ExploreMainViewController {
		.init(viewModel: ExploreViewModelImpl(selectionStore: selectionStore))
	}
	
	func updateUIViewController(_ uiViewController: ExploreMainViewController, context: Context) {
		uiViewController.refreshView()
	}
}
