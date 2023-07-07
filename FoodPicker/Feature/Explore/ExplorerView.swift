//
//  ExplorerView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/6/7.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import SwiftUI

struct ExplorerView: UIViewControllerRepresentable {
	@StateObject var viewModel = ExploreViewModelImpl()
	typealias UIViewControllerType = ExploreMainViewController
	
	func makeUIViewController(context: Context) -> ExploreMainViewController {
		.init(viewModel: viewModel)
	}
	
	func updateUIViewController(_ uiViewController: ExploreMainViewController, context: Context) {}
}
