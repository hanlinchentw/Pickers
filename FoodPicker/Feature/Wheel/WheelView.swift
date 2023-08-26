//
//  WheelView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2023/6/28.
//  Copyright © 2023 陳翰霖. All rights reserved.
//

import SwiftUI

struct WheelView: UIViewControllerRepresentable {
	typealias UIViewControllerType = WheelViewController

	@ObservedObject var selectionStore: RestaurantSelectionStore

	func makeUIViewController(context: Context) -> WheelViewController {
		return WheelViewController(selectionStore: selectionStore)
	}
	
	func updateUIViewController(_ uiViewController: WheelViewController, context: Context) {
		uiViewController.refreshWheel()
	}
}
