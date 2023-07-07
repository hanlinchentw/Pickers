//
//  MapView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/6/28.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import SwiftUI

struct MapView: UIViewControllerRepresentable {
	let viewModel: ExploreViewModel

	typealias ViewController = MapViewController
	
	func makeUIViewController(context: Context) -> ViewController {
		return MapViewController(viewModel: viewModel)
	}
	
	func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}
