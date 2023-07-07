//
//  FeedContainerView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/6/30.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import SwiftUI

struct FeedContainerView: UIViewControllerRepresentable {
	let viewModel: ExploreViewModel
	
	typealias UIViewControllerType = FeedViewController
	
	func makeUIViewController(context: Context) -> FeedViewController {
		return FeedViewController(viewModel: viewModel)
	}
	
	func updateUIViewController(_ uiViewController: FeedViewController, context: Context) {}
}
